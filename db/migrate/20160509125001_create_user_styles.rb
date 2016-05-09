class CreateUserStyles < ActiveRecord::Migration
  def change
    create_table :user_styles do |t|
      t.integer :user_id
      t.string :style
      t.string :fuse
      t.string :shencai
      t.string :kangju
      t.string :else

      t.timestamps null: false
    end
  end
end
