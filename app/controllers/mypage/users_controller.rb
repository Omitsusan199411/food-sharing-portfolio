class Mypage::UsersController < ApplicationController

  def show
    @user = current_user
    @profile = Profile.find_by(user_id: current_user.id)
    @address = Address.find_by(user_id: current_user.id)
  end
  
end