class CreateMobileValidates < ActiveRecord::Migration
  def change
    create_table :mobile_validates do |t|
      t.string :code
      t.string :mobile
      t.integer :checked

      t.timestamps null: false
    end
  end
end
