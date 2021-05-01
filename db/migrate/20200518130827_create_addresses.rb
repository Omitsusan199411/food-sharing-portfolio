class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :postal_code,        defalut: ""
      t.string :prefecture,         defalut: ""
      t.string :city,               defalut: ""
      t.string :address_number,     defalut: ""
      t.string :building,           defalut: ""
      t.integer :user_id, null: false, foregin_key: true, index: {unique: true}
      t.timestamps
    end
  end
end
