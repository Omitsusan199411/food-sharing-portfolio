class CreateShopDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_details do |t|
      t.string  :photo
      t.text    :introduction,    null: false, defalut: ""
      t.integer :genre,           null: false, defalut: 1
      t.string  :location,        null: false, defalut: ""
      t.time    :start_time,      null: false
      t.time    :end_time,        null: false
      t.string  :holiday,         defalut: ""
      t.integer :shop_id,         null: false, foregin_key: true
      t.timestamps
    end
  end
end
