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
      t.string :result_url
      t.string :success_url
      t.string :cancel_url

      t.timestamps null: false
    end
  end
end
