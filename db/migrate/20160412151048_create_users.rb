class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :invite_id
      t.integer :designer_id
      t.string :name
      t.string :mobilephone
      t.integer :age
      t.string  :sex
      t.string  :birthday
      t.string  :email
      t.string  :password
      t.string  :invitecode
      t.string  :amount
      t.string  :invite_amount
      t.string  :month_amount

      t.timestamps null: false
    end
  end
end
