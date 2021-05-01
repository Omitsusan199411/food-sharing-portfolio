class ShopDetail < ApplicationRecord
  belongs_to :shop, optional: true

  enum genre:{
    japanese_food:1, noodles:2, fishes:3, local_cuisine:4, chinese_food:5, french:6,
    italian:7, meats:8, izakaya:9, skewers:10, fast_food:11,
    casserole:12, viking:13, bread:14, cafe:15, other:16
  }

  with_options presence: {message: "を入力してください"} do
    validates :genre
    validates :location, uniqueness: {message: "が他店舗と重複しています"}
    validates :start_time
    validates :end_time
  end

end
