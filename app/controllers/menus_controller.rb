class MenusController < ApplicationController
  before_action :authenticate_user!

  def index
    @menus = current_user.menus.page(params[:page]).per(10)
  end

  def show
    @menu = Menu.find_by(id: params[:id])
    if current_user.admin? || current_user.id == @menu.user_id
      @ingredients = Ingredient.where(menu_id: @menu.id)
      @preparations = Preparation.where(menu_id: @menu.id)
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
      render new_menu_path
    end
  end

  def edit
    @menu = Menu.find_by(id: params[:id])
    unless current_user.id == @menu.user_id
      redirect_to root_path
    end
  end

  def update
    @menu = Menu.find_by(id: params[:id])
    if current_user.id == @menu.user_id
      if  @menu.update_attributes(menu_params)
        flash[:primary] = "編集しました。"
        redirect_to menus_path
      else
        flash[:danger] = "編集できませんでした。"
        redirect_to edit_menu_path
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    menu = Menu.find_by(id: params[:id])
    if menu.destroy
      if current_user.id == menu.user_id || current_user.admin?
        flash[:primary] = "メニューを削除しました"
        if current_user.admin?
          redirect_to admin_path(menu.user_id)
        else
          redirect_to menus_path
        end
      else
        render 'index'
        flash[:danger].now = "メニューの削除に失敗しました"
      end
    else
      redirect_to root_path
    end
  end

  private

    def menu_params
      params.require(:menu).permit(:id, :name, :recipe, :memo, :status,
            :user_id, :type_id, :genre_id, :image, ingredients_attributes: [:id, :menu_id, :item, :quantity, :_destroy],
               preparations_attributes: [:id, :menu_id, :step, :_destroy])
    end

end