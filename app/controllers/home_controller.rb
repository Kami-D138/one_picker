class HomeController < ApplicationController
  
  def top
    @user = User.find_by(id: params[:id]) if user_signed_in?
    @menus = Menu.all
    if user_signed_in?
      @original_menus = current_user.menus
    end
  end

  def sample
    @user = User.find_by(id: params[:id]) if user_signed_in?
    @menus = Menu.all
    @menu = Menu.all.sample
    if user_signed_in?
      @original_menus = current_user.menus
    end
  end

  def my_sample
    @user = User.find_by(id: params[:id]) if user_signed_in?
    @menus = Menu.all
    @menu = current_user.menus.sample
    if user_signed_in?
      @original_menus = current_user.menus
    end
  end

end
