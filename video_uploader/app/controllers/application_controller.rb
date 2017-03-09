class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :display_status, if: -> { params[:status].present? }

  def display_status
    status = params[:status].to_sym
    flash.now[status] = params[:message]
  end
end
