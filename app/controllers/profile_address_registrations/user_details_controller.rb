class ProfileAddressRegistrations::UserDetailsController < ApplicationController

  def new_profile
    @profile = Profile.new
  end

  def create_profile
    @profile = Profile.new(profile_params)
    unless @profile.valid?
      render :new_profile and return
    end
    session[:profile] = @profile
    @address = Address.new
    render :new_address
  end

  def new_address
    @address = Address.new
  end

  def create_address
    @profile = Profile.new(session[:profile])
    @address = Address.new(address_params)
    unless @address.valid?
      render :new_address and return
    end
    if @profile.save && @address.save
      session[:profile].clear
      flash[:notice] = "詳細情報を登録しました"
      redirect_to root_path and return
    else
      render :new_profile and return
      flash[:alert] = "登録できませんでした"
    end
  end

  def postal_search
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
      @address = Address.new
    else
      flash[:alert] = "その郵便番号は検索できませんでした"
      @address = Address.new
    end
    render :new_address
  end


  private
  def profile_params
    params.require(:profile).permit(:photo, :family_name, :last_name, :j_family_name, :j_last_name, :sex, :birthday, :phone_number).merge(user_id: current_user.id)
  end

  def address_params
    params.require(:address).permit(:postal_code, :prefecture, :city, :address_number, :building).merge(user_id: current_user.id)
  end

end
