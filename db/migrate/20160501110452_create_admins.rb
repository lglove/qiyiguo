class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email
      t.string :mobilephone
      t.string :admin
      t.string :password

      t.timestamps null: false
    end
  end
end
