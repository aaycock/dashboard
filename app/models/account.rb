class Account < ActiveRecord::Base
  #validates_presence_of :name, :contact_email
  has_many :services

  PLANS = [ ["Small", "db-small"],
            ["Medium", "db-medium"],
            ["Large", "db-large"] ]

end
