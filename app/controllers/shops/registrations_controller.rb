# frozen_string_literal: true

class Shops::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_account_update_params, only: [:update]
  before_action :configure_sign_up_shop_params, only: [:create]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  def new
    @shop = Shop.new
  end

  def create
    @shop =  Shop.new(sign_up_params)
    if @shop.invalid?
      render :new and return
    else
      session["shop_regist_data"] = {shop: @shop.attributes}
      session["shop_regist_data"][:shop]["password"] = params[:shop][:password]
      @shop_detail = @shop.build_shop_detail
      render :new_shop_detail
    end
  end

  def new_shop_detail
    
  end

  def create_shop_detail
    @shop = Shop.new(session["shop_regist_data"]["shop"])
    @shop_detail = ShopDetail.new(shop_detail_params)
    unless @shop_detail.valid?
      render :new_shop_detail and return
    else
      @shop.build_shop_detail(@shop_detail.attributes)
    end
    if @shop.save
      session["shop_regist_data"]["shop"].clear
      sign_in(:shop, @shop)
      flash[:notice] = "店舗情報を登録しました"
      redirect_to root_path and return
    else
      flash.now[:alert] = '新規登録に失敗しました'
      render :new and return
    end
  end


  protected

  def configure_sign_up_shop_params
    devise_parameter_sanitizer.permit(:sign_up, keys:[:name, :phone_number, :admin, :email])
  end

  def shop_detail_params
    start = Time.zone.local(params[:shop_detail]["start_time(1i)"].to_i, params[:shop_detail]["start_time(2i)"].to_i, params[:shop_detail]["start_time(3i)"].to_i, params[:shop_detail]["start_time(4i)"].to_i, params[:shop_detail]["start_time(5i)"].to_i)
    last = Time.zone.local(params[:shop_detail]["end_time(1i)"].to_i, params[:shop_detail]["end_time(2i)"].to_i, params[:shop_detail]["end_time(3i)"].to_i, params[:shop_detail]["end_time(4i)"].to_i, params[:shop_detail]["end_time(5i)"].to_i)
    params.require(:shop_detail).permit(:photo, :introduction, :genre, :location, holiday: []).merge(start_time: start, end_time: last)
  end
end