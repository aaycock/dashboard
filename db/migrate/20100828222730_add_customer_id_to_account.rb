class AddCustomerIdToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :customer_id, :integer
  end

  def self.down
    remove_column :accounts, :customer_id
  end
end
