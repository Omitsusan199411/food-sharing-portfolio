module V1
  class ShopResetPasswordsController < ApplicationController

    def create
      @shop = Shop.find_by(email: shop_create_params[:email])
      if Shop.pluck(:email).include?(params[:shop][:email])
        @shop&.send_reset_password_instructions
        respond_to do |format|
          format.html {render :create}
          format.json {render json: @shop}
        end
        session[:shop_email] = params[:shop][:email]
      else
        if params[:shop][:email].blank?
          flash[:alert] = "メールアドレスを入力してください"
          redirect_to new_shop_password_path and return
        else
          flash[:alert] = "そのメールアドレスは登録されていません"
          redirect_to new_shop_password_path and return
        end
      end 
    end

    def update
      @shop = Shop.find_by(id: params[:id])
      shop = @shop.update(shop_update_params)
      if shop == false
        render "/shops/passwords/edit" and return
      else
        flash[:notice] = "パスワードを変更しました"
        session[:shop_email].clear
        respond_to do |format|
          format.html {redirect_to new_shop_session_path}
          format.json {render json: shop, status: :ok, serializer: V1::ShopSerializer}
        end
      end
    end

    protected
    def shop_create_params
      params.require(:shop).permit(:email)
    end

    def shop_update_params
      params.require(:shop).permit(:password, :password_confirmation, :reset_password_token, :id)
    end
  end
end