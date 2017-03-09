module ApplicationHelper
  def is_events_page?
    params[:controller] == 'events'
  end

  def is_presentation_page?
    params[:controller] == 'presentations'
  end
end
