class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :order_id
      t.string :amount
      t.string :channel
      t.string :currency
      t.string :client_ip
      t.string :status
      t.string :paid_at

      t.timestamps null: false
    end
  end
end
