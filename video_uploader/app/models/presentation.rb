class Presentation < ApplicationRecord
  validates_presence_of :title, :description, :presented_at

  def needs_video?
    %w(pending failed_to_process failed_to_publish).include?(status)
  end
end
