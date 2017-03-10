class EventsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @current_page = (params[:page] || 1).to_i
    @events = Event.active.order('event_date ASC').page(@current_page)
    @total_records = @events.total_count
  end

  def destroy
    event = Event.find(params[:id])
    event.update(active: false)

    redirect_to events_path, notice: "\"#{event.title}\" was marked as hidden."
  end
end
