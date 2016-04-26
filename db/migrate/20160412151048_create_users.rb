class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :mobilephone
      t.integer :age
      t.string  :sex
      t.string  :birthday

      t.timestamps null: false
    end
  end
end
