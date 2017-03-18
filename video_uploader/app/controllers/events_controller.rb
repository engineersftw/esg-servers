class EventsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @current_page = (params[:page] || 1).to_i
    @events = Event.active.includes(:presentations).order('event_date ASC, title ASC').page(@current_page)
    @total_records = @events.total_count
  end

  def search
    @search = search_param[:search]
    @event_date = search_param[:event_date]
    @events = []

    if @search.present? || @event_date.present?
      @events = Event.active.order('event_date ASC')
      @events = @events.where("lower(title) like :term or lower(description) like :term", {term: "%#{@search.downcase}%"}) if @search.present?
      @events = @events.where(event_date: @event_date) if @event_date.present?
    end
  end

  def destroy
    event = Event.find(params[:id])
    event.update(active: false)

    redirect_to events_path, notice: "\"#{event.title}\" was marked as hidden."
  end

  private

  def search_param
    params.permit(:search, :event_date)
  end
end
