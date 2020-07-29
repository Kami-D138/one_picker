class MenusController < ApplicationController
  before_action :authenticate_user!


  def index
    @menus = current_user.menus.all
  end

  def show
    @menu = Menu.find_by(id: params[:id])
    if current_user.admin? || current_user.id == @menu.user_id
      @ingredients = Ingredient.where(menu_id: @menu.id)
      @preparations = Preparation.where(menu_id: @menu.id)
    else 
      redirect_to '/'
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
      flash[:success] = "投稿しました。"
      redirect_to menus_path
    else 
      flash.now[:danger] = "投稿できませんでした。"
      render 'new'
    end
  end

  def edit
    @menu = Menu.find_by(id: params[:id])
    unless current_user.id == @menu.user_id 
      redirect_to '/'
    end
  end

  def update 
    @menu = Menu.find_by(id: params[:id])
    if current_user.id == @menu.user_id
      if  @menu.update_attributes(menu_params)
        flash[:success] = "編集しました。"
        redirect_to menus_path
      else 
        flash.now[:danger] = "編集できませんでした。"
        render 'edit'
      end
    else 
      redirect_to '/'
    end
  end 

  def destroy 
    menu = Menu.find_by(id: params[:id])
    if menu.destroy
      if current_user.id == menu.user_id || current_user.admin?  
        flash[:success] = "メニューを削除しました"
        if current_user.admin == true
          redirect_to admins_path
        else
          redirect_to menus_path
        end
      else 
        render 'index'
        flash[:danger].now = "メニューの削除に失敗しました"
      end
    else 
      redirect_to '/'
    end
  end 

  private 

    def menu_params
      params.require(:menu).permit(:name, :recipe, :memo, :status, 
            :user_id, :type_id, :genre_id, :image, ingredients_attributes: [:id, :item, :quantity, :_destroy], preparations_attributes: [:id, :step, :_destroy])
    end

end