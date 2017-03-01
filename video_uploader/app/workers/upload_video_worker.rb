class UploadVideoWorker
  include Sidekiq::Worker

  def perform(title, description, video_file)
    file_path = File.join(Rails.root, 'uploaded', video_file, 'normalized', "#{video_file}-norm.mp4")

    puts "Preparing to upload: #{file_path}"
    if File.file?(file_path)

      options = {
          title: title,
          description: description,
          file: file_path
      }
      begin
        YoutubeService.new.upload_video(options)
      rescue Google::APIClient::TransmissionError => e
        puts e.result.body
      end
    else
      puts "Error: #{file_path} does not exist."
    end

    puts 'Done.'
  end
end
