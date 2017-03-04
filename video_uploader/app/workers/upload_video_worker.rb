class UploadVideoWorker
  include Sidekiq::Worker

  def perform(title, description, video_file)
    file_path = File.join(ENV['UPLOAD_FOLDER'], video_file, 'normalized', "#{video_file}-norm.mp4")

    puts "Preparing to upload: #{file_path}"
    if File.file?(file_path)

      options = {
          title: title,
          description: description,
          file: file_path
      }
      begin
        youtube_service = YoutubeService.new
        api_response = youtube_service.upload_video(options)
        puts "Video id '#{api_response.try(:data).try(:id)}' was successfully uploaded."

        PublishToPlaylistWorker.perform_async(ENV['PLAYLIST_ID'], api_response.data.id)
      rescue Google::APIClient::TransmissionError => e
        puts e.result.body
      end
    else
      puts "Error: #{file_path} does not exist."
    end

    puts 'Done.'
  end
end
