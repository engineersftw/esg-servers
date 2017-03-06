class Presentation < ApplicationRecord
  def needs_video?
    %w(pending failed_to_process failed_to_publish).include?(status)
  end
end
