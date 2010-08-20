class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.string :contact_firstname
      t.string :contact_lastname
      t.string :contact_email
      t.date :start_date
      t.string :plan

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
