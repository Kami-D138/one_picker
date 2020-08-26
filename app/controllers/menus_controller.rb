class MenusController < ApplicationController
  before_action :authenticate_user!
  before_action :set_menu, except:[:index, :new, :create]

  def index
    @menus = current_user.menus.page(params[:page]).per(10)
  end

  def show
    if current_user.admin? || current_user.id == @menu.user_id
      set_menu_details
    else
      redirect_to root_path
    end
  end

  def new
    @menu = Menu.new
    @menu.ingredients.build
    @menu.preparations.build
  end

  def create
    @menu = current_user.menus.build(menu_params)
    if @menu.save
      flash[:primary] = "投稿しました。"
      redirect_to menus_path
    else
      flash.now[:danger] = "投稿できませんでした。"
      render "new"
    end
  end

  def edit
    redirect_to root_path unless current_user.id == @menu.user_id
  end

  def update
    if current_user.id == @menu.user_id
      if  @menu.update_attributes(menu_params)
        flash[:primary] = "編集しました。"
        redirect_to menus_path
      else
        flash.now[:danger] = "編集できませんでした。"
        render "edit"
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    if @menu.destroy
      if current_user.admin? || current_user.id == @menu.user_id
        flash[:primary] = "メニューを削除しました"
        if current_user.admin?
          redirect_to admin_path(@menu.user_id)
        else
          redirect_to menus_path
        end
      else
        flash[:danger].now = "メニューの削除に失敗しました"
        render 'index'
      end
    else
      redirect_to root_path
    end
  end


  private

    def set_menu
      @menu = Menu.find_by(id: params[:id])
    end

    def menu_params
      params.require(:menu).permit(:id, :name, :recipe, :memo, :status,
            :user_id, :sub_genre_id, :genre_id, :image, ingredients_attributes: [:id, :menu_id, :item, :quantity, :_destroy],
               preparations_attributes: [:id, :menu_id, :step, :_destroy])
    end

end