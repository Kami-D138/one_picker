class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_admin?

  def users_index
    @users = User.all
  end

  private 
    def user_admin?
      unless current_user.admin == true
        redirect_to '/'
      end
    end

end

