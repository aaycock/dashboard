class Service < ActiveRecord::Base
  belongs_to :account
  belongs_to :dashboard
  has_many :events
end
