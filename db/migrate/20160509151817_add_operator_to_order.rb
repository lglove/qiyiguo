class AddOperatorToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :operator, :string
  end
end
