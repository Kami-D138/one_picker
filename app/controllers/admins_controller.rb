class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_admin?

  def index
    @users = User.all
    @user = User.find_by(id: params[:id])
  end

  def show
    @user = User.find_by(id: params[:id])
    @menus = @user.menus.page(params[:page]).per(10)
  end

  def destroy 
    user = User.find_by(id: params[:id])
    if user.destroy 
      flash[:success] = "ユーザーを削除しました。"
      redirect_to admins_path
    else
      render admins_path
      flash[:danger].now = "ユーザーの削除に失敗しました。"
    end
  end

  private 
    def user_admin?
      redirect_to root_path unless current_user.admin?
    end
end

