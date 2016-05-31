class ChangeMonthAmountFromUsers < ActiveRecord::Migration
  def change
    change_column :users, :amount, :integer
    change_column :users, :invite_amount, :integer
    change_column :users, :month_amount, :integer
  end
end
