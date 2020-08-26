class UsersController < ApplicationController
  before_action :authenticate_user!, :set_user

  def show
  end

  def edit
  end

  def update
    if  @user.update_attributes(user_params)
      flash[:primary] =  "編集しました。"
      redirect_to user_path
    else
      flash.now[:danger] = "編集できませんでした。"
      render "edit"
    end
  end

  def destroy
    if user.destroy
      if current_user.admin?
        redirect_to admins_path
        flash[:primary] = "ユーザーを削除しました。"
      else
        redirect_to root_path
        flash[:primary] =  "ご利用ありがとうございました。"
      end
    end
  end


  private

    def user_params
      params.require(:user).permit(:id, :name, :email)
    end

end
