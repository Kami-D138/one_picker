class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:my_recipe]
  before_action :set_menus, :original_menus_count

  def top
  end

  def common_recipe
    random_number
    @head_or_tail = @num
    if @head_or_tail <= 1
      rakuten_recipe_set
    else
      @menu = Menu.all.sample
      set_menu_details
    end
  end

  def my_recipe
    @menu = current_user.menus.sample
    set_menu_details
  end


  private

    def set_menus
      @menus = Menu.all
    end

    def original_menus_count
      @original_menus = current_user.menus if user_signed_in?
    end


end
