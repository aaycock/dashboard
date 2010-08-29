class AddSubscriptionIdToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :subscription_id, :integer
  end

  def self.down
    remove_column :accounts, :subscription_id
  end
end
