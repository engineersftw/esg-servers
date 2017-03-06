class UploadVideoWorker
  include Sidekiq::Worker
  sidekiq_options queue: :publishing

  def perform(presentation_id, video_file)
    presentation = Presentation.find(presentation_id)
    presentation.update(status: 'publishing_to_youtube')

    file_path = File.join(ENV['UPLOAD_FOLDER'], video_file, 'normalized', "#{video_file}-norm.mp4")

    puts "Preparing to upload: #{file_path}"
    if File.file?(file_path)
      options = {
          title: presentation.title,
          description: presentation.description,
          file: file_path
      }
      begin
        youtube_service = YoutubeService.new
        api_response = youtube_service.upload_video(options)
        puts "Video id '#{api_response.try(:data).try(:id)}' was successfully uploaded."

        presentation.update(status: 'published_to_youtube')
        PublishToPlaylistWorker.perform_async(presentation_id, ENV['PLAYLIST_ID'], api_response.data.id)
      rescue Google::APIClient::TransmissionError => e
        puts e.result.body
        presentation.update(status: 'failed_to_publish')
      end
    else
      puts "Error: #{file_path} does not exist."
      presentation.update(status: 'failed_to_publish')
    end

    puts 'Done.'
  end
end
