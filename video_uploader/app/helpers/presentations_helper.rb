module PresentationsHelper
  def self.badge_color(presentation)
    case presentation.status
      when 'failed_to_process'
      when 'failed_to_publish'
      when 'failed_to_add_to_playlist'
        'red darken-1'

      when 'processing'
      when 'publishing_to_youtube'
        'orange lighten-2'

      when 'published_to_youtube'
      when 'adding_to_playlist'
        'green darken-1'

      else
        'blue darken-1'
    end
  end

  def self.upload_path
    ENV['USE_NGINX_UPLOAD_MODULE'] == '1' ? '/upload_presentation' : '/presentations'
  end
end
