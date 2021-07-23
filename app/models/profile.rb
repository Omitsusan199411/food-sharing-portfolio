class Profile < ApplicationRecord
  belongs_to :user

  mount_uploader :photo, ImageUploader
  
  validates :family_name, :last_name, format: {with: /\A[ぁ-んァ-ン一-龥]/, message: 'は全角で入力してください'}, allow_blank: true
  validates :j_family_name, :j_last_name, format: {with: /\A[ァ-ヶー－]+\z/, message: 'は全角カタカナで入力してください'}, allow_blank: true
  validates :phone_number, format: {with: /\A[0-9]+\z/, message: 'は半角数字で入力してください'}, allow_blank: true
  validates :phone_number, format: {with: /\A\d{10}$|^\d{11}\z/, message: 'はハイフンなしの数字で入力してください'}, allow_blank: true
  
  enum sex: { 男性:1, 女性:2 }

end
