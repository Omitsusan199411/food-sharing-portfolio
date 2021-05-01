class ApplicationController < ActionController::Base

  require 'net/http'

  # ログイン後のリダイレクト先をそれぞれのモデルで設定
  def after_sign_in_path_for(resource)
    case resource
      when User
        root_path
      when Shop
        root_path
      end
  end
end
