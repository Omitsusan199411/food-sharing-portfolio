class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :photo
      t.string :family_name,         defalut: ""
      t.string :last_name,           defalut: ""
      t.string :j_family_name,       defalut: ""
      t.string :j_last_name,         defalut: ""
      t.integer :sex,                defalut: ""
      t.date   :birthday
      t.string :phone_number,        defalut: ""
      t.integer :user_id,            null: false, foregin_key: true, index: {unique: true}
      t.timestamps
    end
  end
end
