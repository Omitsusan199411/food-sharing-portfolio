# README
## food_share_app DB設計
### usersテーブル
|Column|Type|Options|
|------|----|-------|
|nickname|string|null: false, index: true|
|photo|string|
|email|string|null: false, unique: true, defalut: ""|
|password|string|null: false, unique: true, defalut: ""|
|phone_number|string|null: false, unique: true|
|family_name|string|null: false|
|last_name|string|null: false|
|j_family_name|string|null: false|
|j_last_name|string|null: false|
|sex|integer|
|birthday|date|null: false|

### usersテーブル アソシエーション
- has_one :card
- has_one :cart
- has_one :address
- has_many :transactions
- has_many :products, through: :transactions
- has_many :orders
- has_many :user_shop_reviews
- has_many :shops, through: :user_shop_reviews, dependent: :destroy
- has_many :follows
- has_many :shops, through: :follows, dependent: :destroy

### addressesテーブル
|Column|Type|Options|
|------|----|-------|
|postal_code|string|null: false|
|prefecture|integer|null: false|
|city|string|null: false|
|address_number|string|null: false|
|building|string|null: false|
|user_id|integer|null: false, foregin_key: true|

### addressesテーブル アソシエーション
- belongs_to :user

### shopsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true, index: true|
|phone_number|string|null: false, unique: true|
|password|string|null: false, unique: true, defalut: ""|
|admin|string|null: false, defalut: ""|

### shopsテーブル アソシエーション
- has_many :user_shop_reviews
- has_many :users, through: :user_shop_reviews, dependent: :destroy
- has_many :follows
- has_many :users, through: :follows, dependent: :destroy
- has_many :products

### shop_detailsテーブル
|Column|Type|Options|
|------|----|-------|
|photo|string|
|introduction|text|null: false|
|genru|integer|null: false, defalut: "1"|
|phone_number|string|null: false, unique: true|
|admin|string|null: false|


### shop_detailsテーブル　アソシエーション
- belongs_to :shop



### productsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, index: true|
|price|integer|null: false|
|context|text|null: false|
|stock|integer|null: false|
|status|integer|null: false|
|trading_time|time|null: false|
|category_id|integer|null: false, foregin_key: true|
|shop_id|integer|null: false, foregin_key: true|

### productsテーブル アソシエーション
- belongs_to :shop
- belongs_to :category
- has_many :transactions
- has_many :users, through: :transactions
- has_many :images, dependent: :destroy

### imagesテーブル
|Column|Type|Options|
|------|----|-------|
|photo|string|null: false|
|product_id|integer|null: false, foregin_key: true|

### imagesテーブル アソシエーション
- belongs_to :product


### categoriesテーブル
|Column|Type|Option|
|------|----|------|
|name|string|null: false, unique: true|

### categoriesアソシエーション
- has_many: :products

### user_shop_reviewsテーブル
|Column|Type|Options|
|------|----|-------|
|context|text|
|rate|float|null: false|
|shop_id|integer|null: false, foregin_key: true|
|user_id|integer|null: false, foregin_key: true|

### user_shop_reviewsアソシエーション
- belongs_to :shop
- belongs_to :user

### followsテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foregin_key: true|
|shop_id|integer|null: false, foregin_key: true|

### followsアソシエーション
- belongs_to :shop
- belongs_to :user

### transactionsテーブル
|Column|Type|Options|
|------|----|-------|
|product_id|integer|null: false, foregin_key: true|
|user_id|integer|null: false, foregin_key: true|

### transactionsアソシエーション
- belongs_to :product
- belongs_to :user

### orderテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foregin_key: true|

### ordersアソシエーション
- belongs_to :user

### cartsテーブル
|Column|Type|Options|
|------|----|------|
|user_id|integer|null: false, foregin_key: true|

### cartsアソシエーション
- belongs_to :user

### cardsテーブル
|Column|Type|Options|
|------|----|------|
|card_id|string|null: false|
|customer_id|string|null: false|
|user_id|integer|null: false, foregin_key: true|

### cardsアソシエーション
- belongs_to :user