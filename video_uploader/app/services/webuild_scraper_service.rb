require 'faraday'

class WebuildScraperService
  def scrape
    response = Faraday.get 'https://webuild.sg/api/v1/events'
    sessions = JSON.parse(response.body, symbolize_names: true)

    sessions[:events].collect do |session|
      presentation = Presentation.where(foreign_uid: "#{session[:platform]}_#{session[:id]}", source: 'webuild').first_or_initialize

      presentation.title = "#{session[:name]} - #{session[:group_name]}"
      presentation.description = build_description(session)
      presentation.presented_at = session[:start_time]

      presentation
    end
  end

  private

  def build_description(payload)
    <<-TEXT
Speaker: 

#{payload[:description]}

Event Page: #{payload[:url]}

Produced by Engineers.SG
    TEXT
  end
end