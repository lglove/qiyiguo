class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :mobilephone
      t.integer :age
      t.integer :invite_id
      t.string  :sex
      t.string  :birthday
      t.string  :password
      t.string  :youxiang
      t.string  :invitecode
      t.string  :email
      t.string  :amount
      t.string  :invite_amount

      t.timestamps null: false
    end
  end
end
