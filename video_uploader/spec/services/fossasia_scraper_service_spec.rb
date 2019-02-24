require 'rails_helper'

RSpec.describe FossasiaScraperService do
  describe '#scrape' do
    before do
      sessions_file = File.join(Rails.root, 'spec', 'fixtures', 'fossasia', 'sessions')
      sessions_json = File.read(sessions_file)
      stub_request(:get, 'https://2019.fossasia.org/event/json/sessions').to_return(body: sessions_json)
    end

    it 'fetches the events' do
      events = subject.scrape

      expect(events.count).to eq 277
      event = events.first

      expect(event).to be_a Event
      expect(event.title).to eq 'Lightning Talk: Update from the BorgBackup Project - FOSSASIA 2019'

      expected_description = <<-TEXT
Speaker(s): Manuel Riel ()

Abstract:
A very short introduction to the open source BorgBackup.

What it can do for you, how you can use it and where we are heading.

Based on the lightning talk given by Thomas Waldmann on 35c3. https://youtu.be/y24_QQjbHFA?t=2627

(Type: Talk | Track: Cloud, Containers, DevOps | Room: )

Event Page: https://2019.fossasia.org
      TEXT
      expect(event.description).to eq expected_description
      expect(event.source).to eq 'fossasia'
      expect(event.foreign_uid).to eq '5163'
      expect(event.status).to eq 'pending'
      expect(event.event_date).to eq Date.parse('2019-03-14')
    end
  end
end

