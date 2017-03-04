class PublishToPlaylistWorker
  include Sidekiq::Worker

  def perform(play_list_id, video_id)
    begin
      puts "Publishing video(#{video_id}) to playlist(#{play_list_id})"

      YoutubeService.new.add_to_playlist(playlist_id: play_list_id, video_id: video_id)
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
  end
end
