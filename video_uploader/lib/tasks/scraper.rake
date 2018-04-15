namespace :scraper do
  desc 'Run Scrapers needed by the app'
  task run: :environment do
    default_task = "scraper:#{ENV['DEFAULT_SCRAPER']}"
    Rake::Task[default_task].invoke
  end

  desc 'FOSSASIA 2018 Sessions'
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
