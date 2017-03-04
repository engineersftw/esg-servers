namespace :scraper do
  desc "FOSSASIA 2017 Sessions"
  task fossasia: :environment do
    presentations = FossasiaScraperService.new.scrape
    puts "Found #{presentations.count} presentations:"
    presentations.each do |p|
      puts "Saving: #{p.title}"
      p.save
    end
    puts "Done."
  end
end
