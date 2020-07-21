class MenusController < ApplicationController
  before_action :authenticate_user!

  def index
    @menus = current_user.menus.all
  end

  def show
    @menu = Menu.find_by(id: params[:id])
  end

  def new
    @menu = Menu.new
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
    @menu = current_user.menus.find_by(id: params[:id])
  end

  def update 
    @menu = Menu.find_by(id: params[:id])
    if  @menu.update_attributes(menu_params)
      flash[:success] = "編集しました。"
      redirect_to menus_path
    else 
      flash.now[:danger] = "編集できませんでした。"
      render 'edit'
    end
  end 

  def destroy 
    if Menu.find_by(id: params[:id]).destroy
      flash[:success] = "メニューを削除しました"
      redirect_to menus_path
    else 
      render 'index'
      flash[:danger] = "メニューの削除に失敗しました"
    end
  end 

  private 

    def menu_params
      params.require(:menu).permit(:name, :recipe, :ingredient,
                    :memo, :status, :user_id, :type_id, :genre_id, :image)
    end

end
