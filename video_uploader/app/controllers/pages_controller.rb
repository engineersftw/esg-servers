class PagesController < ApplicationController
  layout 'widescreen'

  def index
  end

  def screenshots
    @screenshots_base_url = ENV['SCREENSHOT_SVC_BASE_URL']
  end
end
