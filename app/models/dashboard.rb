class Dashboard < ActiveRecord::Base
  belongs_to :account
  has_many :services
end
