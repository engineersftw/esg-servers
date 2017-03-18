require 'faraday'

class EsgService
  def presenters
    begin
      Rails.cache.fetch('all_presenters') do
        response = make_request('presenters')
        response[:presenters]
      end
    rescue
      []
    end
  end

  def organizations
    begin
      Rails.cache.fetch('all_organizations') do
        response = make_request('organizations')
        response[:organizations]
      end
    rescue
      []
    end
  end

  private

  def make_request(path)
    response = Faraday.get 'https://engineers.sg/api/' + path
    JSON.parse(response.body, symbolize_names: true)
  end
end