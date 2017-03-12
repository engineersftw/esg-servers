class Presentation < ApplicationRecord
  validates_presence_of :title, :description, :presented_at
  belongs_to :event, optional: true
  belongs_to :playlist

  scope :active, -> { where(active: true) }

  def needs_video?
    %w(pending failed_to_process failed_to_publish).include?(status)
  end

  def has_video_link?
    video_id.present? && video_source.present?
  end

  def video_link
     if video_source == 'youtube'
       "https://youtu.be/#{video_id}"
     elsif video_source == 'vimeo'
       "https://vimeo.com/#{video_id}"
     end
  end
end
