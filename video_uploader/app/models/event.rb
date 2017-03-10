class Event < ApplicationRecord
  validates_presence_of :title, :description, :event_date
  has_many :presentations

  scope :active, -> { where(active: true) }
end
