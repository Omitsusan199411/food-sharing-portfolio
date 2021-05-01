module V2
  class UserResetPasswordsController < ApplicationController
    def create
      @user = User.find_by(email: user_create_params[:email])
      if User.pluck(:email).include?(user_create_params[:email])
        @user&.send_reset_password_instructions
        respond_to do |format|
          format.html {render :create}
          format.json {render json: @user}
        end
      session[:user_email] = params[:user][:email]
      else
        if params[:user][:email].blank?
          flash[:alert] = "メールアドレスを入力してください"
          redirect_to new_user_password_path and return
        else
          flash[:alert] = "そのメールアドレスは登録されていません"
          redirect_to new_user_password_path and return
        end
      end
    end


    def update
      @user = User.find_by(id: params[:id])
      user = @user.update(user_update_params)
      if user == false
        render '/users/passwords/edit' and return
      else
        flash[:notice] = "パスワードを変更しました"
        session[:user_email].clear
        respond_to do |format|
          format.html {redirect_to new_user_session_path}
          format.json {render json: user}
        end
      end
    end

    protected

    def user_create_params
      params.require(:user).permit(:email)
    end

    def user_update_params
      params.require(:user).permit(:password, :password_confirmation, :reset_passweord_token)
    end
  end
end