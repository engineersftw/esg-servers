class EventsController < ApplicationController
  def index
    @events = Event.where(active: true).order('event_date ASC')
  end

  def destroy
    event = Event.find(params[:id])
    event.update(active: false)

    redirect_to root_path, notice: "\"#{event.title}\" was marked as hidden."
  end
end
