class Event < ActiveRecord::Base

  LEVELS = [
    ["Up", 0],
    ["Info", 1],
    ["Planned", 2],
    ["Degraded", 3],
    ["Down", 4]
  ]

  belongs_to :service
  validates_presence_of :service_id
  validates_presence_of :level


end
