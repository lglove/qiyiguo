class AddAmountDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :amount_date, :datetime
  end
end
