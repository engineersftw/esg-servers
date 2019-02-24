require 'faraday'

class FossasiaScraperService
  def scrape
    response = Faraday.get 'https://2019.fossasia.org/event/json/sessions'
    sessions = JSON.parse(response.body, symbolize_names: true)

    sessions.collect do |session|
      event = Event.where(foreign_uid: "#{session[:id]}", source: 'fossasia').first_or_initialize

      event.title = "#{session[:title]} - FOSSASIA 2019"
      event.description = build_description(session)
      event.event_date = session[:start_time]

      event
    end
  end

  private

  def build_description(payload)
    speakers = payload[:speakers].map do |speaker|
      "#{speaker[:name]} (#{speaker[:city]})#{speaker[:organization].present? ? ', '+speaker[:organization] : ''}"
      end.join("\n")

    <<-TEXT
Speaker(s): #{speakers}

Abstract:
#{sanitize_html(payload[:short_abstract])}

(Type: #{payload[:session_type].try(:[], :name)} | Track: #{payload[:track].try(:[], :name)} | Room: #{payload[:microlocation].try(:[], :name)})

Event Page: https://2019.fossasia.org
    TEXT
  end

  def sanitize_html(html_text)
    doc = Nokogiri::HTML(html_text)
    doc.search('p').map{ |n| n.text }.join("\n\n").strip
  end
end
