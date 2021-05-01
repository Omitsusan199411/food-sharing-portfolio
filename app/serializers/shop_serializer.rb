class ShopSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :admin,
             :email,
             :phone_number,
             :password,
             :password_confirmation
end
