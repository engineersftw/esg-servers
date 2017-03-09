module PresentationsHelper
  def badge_color(presentation)
    case presentation.status
      when 'failed_to_process'
      when 'failed_to_publish'
      when 'failed_to_add_to_playlist'
      when 'failed_to_clean'
        'red darken-1'

      when 'processing'
      when 'publishing_to_youtube'
        'orange lighten-2'

      when 'published_to_youtube'
      when 'adding_to_playlist'
      when 'cleaning_folder'
      when 'cleaned'
        'green darken-1'

      else
        'blue darken-1'
    end
  end

  def upload_path
    ENV['USE_NGINX_UPLOAD_MODULE'] == '1' ? '/upload_presentation' : '/presentations'
  end
end
