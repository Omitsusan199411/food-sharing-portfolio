class CreateUserSnsCredentials < ActiveRecord::Migration[5.2]
  def change
    create_table :user_sns_credentials do |t|
      t.string :provider
      t.string :uid
      t.references :user, foregin_key: true
      t.timestamps
    end
  end
end
