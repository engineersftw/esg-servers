require 'rails_helper'

RSpec.describe WebuildScraperService do
  describe '#scrape' do
    before do
      sessions_file = File.join(Rails.root, 'spec', 'fixtures', 'webuild', 'events')
      sessions_json = File.read(sessions_file)
      stub_request(:get, 'https://webuild.sg/api/v1/events').to_return(body: sessions_json)
    end

    it 'fetches the events' do
      events = subject.scrape

      expect(events.count).to eq 147
      event = events.first

      expect(event).to be_a Presentation
      expect(event.title).to eq 'So You Want to Be a UX Designer - General Assembly Singapore'

      expect(event.source).to eq 'webuild'
      expect(event.foreign_uid).to eq 'facebook_221579128315306'
      expect(event.status).to eq 'pending'
      expect(event.presented_at).to eq Date.parse('2017-03-07')
    end
  end
end
