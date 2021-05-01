class Mypage::UserDetailUpdatesController < ApplicationController

  def new_update_profile
    @profile = Profile.find_by(user_id: current_user.id)
    @validate = Profile.new
  end

  def update_profile
    @profile = Profile.find_by(user_id: current_user.id)
    @validate = Profile.new(profile_params)
    unless @validate.valid?
      render :new_update_profile and return
    end
    @profile.update(profile_params)
    flash[:notice] = "プロフィールを更新しました"
    redirect_to root_path
  end

  def new_update_address
    @address = Address.find_by(user_id: current_user.id) 
  end

  def update_address
    @address = Address.find_by(user_id: current_user.id)
    @address.assign_attributes(address_params)
    unless @address.valid?
      render :new_update_address and return
    end
    @address.update(address_params)
    flash[:notice] = "アドレスを更新しました"
    redirect_to root_path
  end

  def postal_confirm_search
    code = params[:address][:postal_code]
    postal = URI.encode_www_form({zipcode: code})
    uri = URI.parse("https://zipcloud.ibsnet.co.jp/api/search?#{postal}")
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
    if result["results"]
      @zipcode = result["results"][0]["zipcode"]
      @address1 = result["results"][0]["address1"]
      @address2 = result["results"][0]["address2"]
      @address3 = result["results"][0]["address3"]
    else
      flash.now[:alert] = "その郵便番号は検索できませんでした"
    end
    @address = Address.find_by(user_id: current_user.id)
    render :new_update_address
  end


  private
  def profile_params
    params.require(:profile).permit(:photo, :family_name, :last_name, :j_family_name, :j_last_name, :sex, :birthday, :phone_number)
  end

  def address_params
    params.require(:address).permit(:postal_code, :prefecture, :city, :address_number, :building)
  end

end
