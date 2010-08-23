class AddDashboardIdToService < ActiveRecord::Migration
  def self.up
    add_column :services, :dashboard_id, :integer
  end

  def self.down
    remove_column :services, :dashboard_id
  end
end
