class MenusController < ApplicationController

  def index
    @menus = current_user.menus
  end

  def show
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
      flash.now[:danger] = "投稿失敗"
      render 'new'
    end
  end

  def edit
  end

  private 

    def menu_params
      params.require(:menu).permit(:name, :recipe, :ingredient,
                    :memo, :status, :user_id, :type_id, :genre_id)
    end
end
