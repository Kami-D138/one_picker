class HomeController < RakutenapiController
  before_action :authenticate_user!, only: [:my_recipe]
  before_action :set_menus, :original_menus_count

  def top
  end

  def common_recipe
    random_number
    @lot_num = @random_num
    if @lot_num <= 1
      rakuten_recipe_set
    else
      @menu = Menu.all.sample
      set_menu_details
    end
  end

  def my_recipe
    if current_user.menus.any?
      @menu = current_user.menus.sample
      set_menu_details
    else
      flash[:danger] = "レシピがありません。作成して下さい。"
      redirect_to new_menu_path
    end
  end


  private

    def set_menus
      @menus = Menu.all
    end

    def original_menus_count
      @original_menus = current_user.menus if user_signed_in?
    end


end
