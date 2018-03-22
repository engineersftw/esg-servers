require 'faraday'

class FossasiaScraperService
  def scrape
    cal_file = File.open( Rails.root.join('app', 'services', 'FOSSASIA Summit.ics') )

    cals = Icalendar::Calendar.parse(cal_file)
    cal = cals.first

    # sessions.reject!{ |session| ['Breaks','Exhibition'].include?(session[:track].try(:[], :name)) }

    cal.events.collect do |session|
      event = Event.where(foreign_uid: "#{session.uid}", source: 'fossasia').first_or_initialize

      event.title = "#{session.summary} - FOSSASIA 2018"
      event.description = build_description(session)
      event.event_date = session.dtstart

      event
    end
  end

  private

  def build_description(payload)
    description = payload.description
    description = description.join("") if description.class == Icalendar::Values::Array

    <<-TEXT
Speaker: 

#{sanitize_html(description)}

(Type:  | Track:  | Room: #{payload.location})

Event Page: http://2018.fossasia.org

Produced by Engineers.SG
    TEXT
  end

  def sanitize_html(html_text)
    doc = Nokogiri::HTML(html_text)
    doc.search('p').map{ |n| n.text }.join("\n\n").strip
  end
end
