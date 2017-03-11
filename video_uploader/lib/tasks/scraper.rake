namespace :scraper do
  desc 'FOSSASIA 2017 Sessions'
  task fossasia: :environment do
    presentations = FossasiaScraperService.new.scrape
    puts "Found #{presentations.count} presentations:"
    presentations.each do |p|
      puts "Saving: #{p.title}"
      p.save
    end
    puts 'Done.'
  end

  desc 'WebuildSG Events'
  task webuildsg: :environment do
    Rails.logger.info 'Starting scraper for WebuildSG'
    presentations = WebuildScraperService.new.scrape
    Rails.logger.info "Found #{presentations.count} presentations:"
    presentations.each do |p|
      Rails.logger.info "Saving: #{p.title}"
      p.save
    end
    Rails.logger.info 'Done scraping.'
  end
end
