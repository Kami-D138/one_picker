class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    root_path
  end

  def set_menu_details
    @ingredients = Ingredient.where(menu_id: @menu.id)
    @preparations = Preparation.where(menu_id: @menu.id)
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end

  protected

  # 入力フォームからアカウント名情報をDBに保存するために追加
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end


end
