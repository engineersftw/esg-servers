class Playlist < ApplicationRecord
  validates_presence_of :title
  has_many :presentation
end
