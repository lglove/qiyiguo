class CreateAdminAdminMenus < ActiveRecord::Migration
  def change
    create_table :admin_admin_menus do |t|
      t.integer :admin_id
      t.integer :menu_id
      t.timestamps null: false
    end
  end
end
