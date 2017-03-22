class Event < ApplicationRecord
  validates_presence_of :title, :description, :event_date
  has_many :presentations

  scope :active, -> { where(active: true) }
  scope :upcoming, -> { where('event_date >= ?', Time.now.to_date) }
  scope :past, -> { where('event_date < ?', Time.now.to_date) }
end
