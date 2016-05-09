class CreateAdminMenus < ActiveRecord::Migration
  def change
    create_table :admin_menus do |t|
      t.integer :parent_id
      t.string :text
      t.string :url
      t.string :hide, default: false
      t.integer :position, default:100

      t.timestamps null: false
    end
  end

  Admin::Menu.create(text: "内部用户", url: "/admin/admins")
  Admin::Menu.create(text: "订单管理", url: "/admin/orders")
  Admin::Menu.create(text: "视频管理", url: "/admin/videos")
  Admin::Menu.create(text: "外部用户", url: "/admin/users")
  Admin::Menu.create(text: "菜单管理", url: "/admin/menus")
  Admin::Menu.create(text: "设计师管理", url: "/admin/designers")
end
