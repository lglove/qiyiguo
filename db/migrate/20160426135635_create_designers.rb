class CreateDesigners < ActiveRecord::Migration
  def change
    create_table :designers do |t|
      t.string :name
      t.string :mobilephone
      t.string :description

      t.timestamps null: false
    end
  end
end
