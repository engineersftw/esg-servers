require 'rails_helper'

RSpec.describe FossasiaScraperService do
  describe '#scrape' do
    before do
    end

    it 'fetches the events' do
      events = subject.scrape

      expect(events.count).to eq 228
      event = events.second

      expect(event).to be_a Event
      expect(event.title).to eq 'Opentech in Singapore - FOSSASIA 2018'

#       expected_description = <<-TEXT
# Speaker:
#
# FOSSASIA summit had helped brought awareness of Open Source technologies to the general public and enabled collaboration between professionals in the area of ICT (Information &amp Communications Technology). Echoing the Singapore Government’s focus in the developing Singapore's E-commerce and digital economy organisations such as FOSSASIA plays an important role as the melting pot for businesses software developers and government agencies to innovate ICT solutions. Open Source technology can benefit local businesses and workforce. FOSSASIA summit 2018 will cover emerging technologies such as Natural Language Processing using Artificial Intelligence and Distributed technologies like Blockchain thereby opening up new digital frontiers for Singapore SMEs (Small and Medium enterprise) workforce development and Public services. Only because the code is open we are able to talk about it. Open code is a wonderful present to the community.
#
# (Type:  | Track:  | Room: Lecture Theatre)
#
# Event Page: http://2018.fossasia.org
#
# Produced by Engineers.SG
#       TEXT
#       expect(event.description).to eq expected_description
      expect(event.source).to eq 'fossasia'
      expect(event.foreign_uid).to eq '52942146-7045-4f42-84f7-db1f36dcd927'
      expect(event.status).to eq 'pending'
      expect(event.event_date).to eq Date.parse('2018-03-22')
    end
  end
end

