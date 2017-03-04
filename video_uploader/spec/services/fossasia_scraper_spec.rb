require 'rails_helper'

RSpec.describe FossasiaScraperService do
  describe '#scrape' do
    before do
      sessions_file = File.join(Rails.root, 'spec', 'fixtures', 'fossasia', 'sessions')
      sessions_json = File.read(sessions_file)
      stub_request(:get, "http://2017.fossasia.org/json/sessions").to_return(body: sessions_json)
    end

    it 'fetches the events' do
      events = subject.scrape

      expect(events.count).to eq 201
      event = events.first

      expect(event).to be_a Presentation
      expect(event.title).to eq 'Migrating Legacy Backends to Serverless in Parallel'

      expected_description = <<-TEXT
Speaker(s): Rumesh Eranga Hapuarachchi (Colombo)

Abstract:
Like many developers, we had to deal with a back-end written in Ruby 1.8 and we discovered the awesomeness of Serverless. Migrating entire back-end at once is not a piece of cake but the capabilities of Serverless computing allowed us to migrate back-end from Ruby to AWS Lambda functions. We encountered lot of pitfalls along the journey and in this session I am planning to share my experiences on migrating legacy back-ends to Serverless and how to plan parallel migrations avoiding long waiting release cycles.

(Type: Talk | Track: DevOps | Room: Dalton)

Event Page: http://2017.fossasia.org

Produced by Engineers.SG
      TEXT
      expect(event.description).to eq expected_description
      expect(event.source).to eq 'fossasia'
      expect(event.foreign_uid).to eq '3027'
      expect(event.status).to eq 'pending'
      expect(event.presented_at).to eq Date.parse('2017-03-19')
    end
  end
end

