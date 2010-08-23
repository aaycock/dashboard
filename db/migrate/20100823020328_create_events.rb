class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.timestamp :timestamp
      t.integer :level
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
