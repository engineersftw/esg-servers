class Playlist < ApplicationRecord
  validates_presence_of :title
  has_many :presentation

  scope :active, ->{ where(active: true) }

  def has_playlist_link?
    playlist_uid.present? && playlist_source.present?
  end

  def playlist_link
     if playlist_source == 'youtube'
       "https://www.youtube.com/playlist?list=#{playlist_uid}"
     elsif playlist_source == 'vimeo'
       "https://vimeo.com/#{playlist_uid}"
     end
  end
end
