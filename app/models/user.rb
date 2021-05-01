class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2 facebook]
         
  has_one :address, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :user_sns_credentials, dependent: :destroy

  validates :nickname, presence: {message:'を入力してください'}
  validates :email, presence: {message:'を入力してください'}, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, massage:'メールアドレスには@を入れてください'}, uniqueness: true

#oauth認証
  def self.without_sns_data(auth)
    user = User.where(email: auth.info.email).first
      if user.present?
        sns = UserSnsCredential.create(uid: auth.uid, provider: auth.provider, user_id: user.id)
      else
        user = User.new(nickname: auth.info.name, email: auth.info.email)
        sns = UserSnsCredential.new(uid: auth.uid, provider: auth.provider)
      end
      return{ user: user, sns: sns}
  end

  def self.with_sns_data(auth, usersnscredential)
    user = User.where(id: usersnscredential.user_id).first
    #userが存在しなかった場合
    unless user.present?
      user = User.new(nickname: auth.info.name, email: auth.info.email)
    end
    return {user: user}
  end

  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    #firstを付けてusersnscredentialモデルから配列で取得しないとようにしている(二段階認証は配列で取得するため)
    usersnscredential = UserSnsCredential.where(uid: uid, provider: provider).first
    if usersnscredential.present?
      #with_sns_dataメソッドはuserクラスのメソッドなので、userクラス内では呼び出せる。
      user = User.with_sns_data(auth, usersnscredential)[:user]
      sns = usersnscredential
    else
      user = User.without_sns_data(auth)[:user]
      sns = User.without_sns_data(auth)[:sns]      
    end
    return{ user: user, sns: sns}
  end

  def self.user_sns_create(user, sns)
    password = Devise.friendly_token.first(7)
    @user = User.create(nickname: user.nickname, email: user.email, password: password, password_confirmation: password)
    UserSnsCredential.create(user_id: @user.id, uid: sns.uid, provider: sns.provider)
    return {user: @user}
  end

  
end
