class AddDesignidToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :designer_id, :integer
  end
end
