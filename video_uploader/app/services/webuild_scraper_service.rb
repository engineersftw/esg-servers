require 'faraday'

class WebuildScraperService
  def scrape
    response = Faraday.get ENV['WEBUILDSG_EVENT_URL'] || 'https://webuild.sg/api/v1/events'
    sessions = JSON.parse(response.body, symbolize_names: true)

    sessions[:events].collect do |session|
      event = Event.where(foreign_uid: "#{session[:platform]}_#{session[:id]}", source: 'webuild').first_or_initialize

      event.title = "#{session[:name]} - #{session[:group_name]}"
      event.description = build_description(session)
      event.event_date = session[:start_time]

      event
    end
  end

  private

  def build_description(payload)
    <<-TEXT
Speaker:

#{payload[:description]}

Event Page: #{payload[:url]}

Produced by Engineers.SG
Recorded by:
    TEXT
  end
end
