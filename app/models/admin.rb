class Admin < ActiveRecord::Base
    has_and_belongs_to_many :menu, :join_table=>"admin_admin_menus", :class_name=>"Admin::Menu", foreign_key: "admin_id", association_foreign_key: "menu_id"
  def self.md5(text)
    Digest::MD5.hexdigest(text)
  end
end
