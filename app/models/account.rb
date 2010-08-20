class Account < ActiveRecord::Base
  validates_presence_of :name, :contact_email
  has_many :services
end
