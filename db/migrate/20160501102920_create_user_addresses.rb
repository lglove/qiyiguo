class CreateUserAddresses < ActiveRecord::Migration
  def change
    create_table :user_addresses do |t|
      t.integer :user_id
      t.string :name
      t.string :address

      t.timestamps null: false
    end
  end
end
