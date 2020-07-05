class HomeController < ApplicationController
  def top
    @user = User.find_by(id: params[:id]) if user_signed_in?
  end
end
