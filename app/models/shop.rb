class Shop < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  devise :database_authenticatable, :authentication_keys => [:name]

  #アソシエーション
  has_one :shop_detail, dependent: :destroy

  with_options presence: {message: "を入力してください"} do
    validates :name
    validates :admin
    validates :phone_number
    validates :email
    with_options uniqueness: {message: "が他店舗と重複しています"} do
      validates :name
      validates :phone_number
      validates :email
    end
  end

  validates :phone_number, numericality: { only_integer: true}, length: { in: 10..11}
  validates :admin, admin_check: true
  validates :email, email_check: true


  #emailをdevsieの必須項目から外す
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end
  #------------------------------

  #deviseのログインをcookieで維持する
  def remember_me
    true
  end
  # ------------------------------

end