class AdminsController < ApplicationController
  before_action :authenticate_user!, :user_admin?, :set_user

  def index
    @users = User.all.page(params[:page]).per(20)
  end

  def show
    @menus = @user.menus.page(params[:page]).per(10)
  end

  def destroy
    if @user.destroy
      flash[:primary] = "ユーザーを削除しました。"
      redirect_to admins_path
    else
      flash[:danger].now = "ユーザーの削除に失敗しました。"
      render admins_path
    end
  end


  private

    def user_admin?
      redirect_to root_path unless current_user.admin?
    end

end

