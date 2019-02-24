require 'faraday'

class FossasiaScraperService
  def scrape
    response = Faraday.get 'http://2017.fossasia.org/json/sessions'
    sessions = JSON.parse(response.body, symbolize_names: true)

    sessions.reject!{ |session| ['Breaks','Exhibition'].include?(session[:track].try(:[], :name)) }

    sessions.collect do |session|
      event = Event.where(foreign_uid: "#{session[:id]}", source: 'fossasia').first_or_initialize

      event.title = "#{session[:title]} - FOSSASIA 2017"
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

Event Page: http://2017.fossasia.org

Produced by Engineers.SG
    TEXT
  end

  def sanitize_html(html_text)
    doc = Nokogiri::HTML(html_text)
    doc.search('p').map{ |n| n.text }.join("\n\n").strip
  end
end
