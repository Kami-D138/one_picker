class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:my_sample]

  def top
    @menus = Menu.all
    if user_signed_in?
      @original_menus = current_user.menus
    end
  end

  def common_recipe
    @menus = Menu.all
    @menu = Menu.all.sample
    if user_signed_in?
      @original_menus = current_user.menus
    end
  end

  def my_recipe
    @menus = Menu.all
    @menu = current_user.menus.sample
    if user_signed_in?
      @original_menus = current_user.menus
    end
  end

end
