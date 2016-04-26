class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :price
      t.string :name
      t.string :status
      t.string :express

      t.integer :user_id

      t.timestamps null: false
    end
  end
end
