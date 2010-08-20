class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.integer :account_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
