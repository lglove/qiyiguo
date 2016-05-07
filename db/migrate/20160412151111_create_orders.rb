class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :price
      t.string :order_number
      t.string :name
      t.string :mobilephone
      t.string :status
      t.string :paid
      t.string :express
      t.string :address
      t.string :receiver
      t.string :kuaidi_sn


      t.timestamps null: false
    end
  end
end
