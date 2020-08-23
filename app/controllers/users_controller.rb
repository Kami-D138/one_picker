class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    unless @user.admin? || @user.id == current_user.id
      redirect_to root_path
      flash[:danger] = "不正なアクセスです。"
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
    unless @user.admin? || @user.id == current_user.id
      redirect_to root_path
      flash[:danger] = "不正なアクセスです。"
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.admin? || @user.id == current_user.id
      if  @user.update_attributes!(user_params)
        flash[:primary] =  "編集しました。"
        redirect_to user_path
      else
        flash[:danger] = "編集できませんでした。"
        redirect_to user_path
      end
    else
      flash[:danger] = "不正なアクセスです。"
      redirect_to root_path
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    unless user.id == current_user.id || @user.admin?
      redirect_to root_path
      flash[:danger] = "不正なアクセスです。"
    else
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
  end


  private

    def user_params
      params.require(:user).permit(:id, :name, :email)
    end

end
