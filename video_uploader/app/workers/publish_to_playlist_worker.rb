class PublishToPlaylistWorker
  include Sidekiq::Worker

  def perform(presentation_id)
    presentation = Presentation.find(presentation_id)
    presentation.update(status: 'adding_to_playlist')

    if presentation.playlist == nil
      presentation.update(status: 'no_playlist_defined')
    else
      begin
        puts "Publishing video(#{presentation.video_id}) to playlist(#{presentation.playlist.playlist_uid})"

        YoutubeService.new.add_to_playlist(playlist_id: presentation.playlist.playlist_uid, video_id: presentation.video_id)
        presentation.update(status: 'added_to_playlist')

        CleanupWorker.perform_async(presentation_id)
      rescue Google::APIClient::TransmissionError => e
        presentation.update(status: 'failed_to_add_to_playlist')
        puts e.result.body
      end
    end
  end
end
