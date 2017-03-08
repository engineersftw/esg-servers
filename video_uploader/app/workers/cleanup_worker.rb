class CleanupWorker
  include Sidekiq::Worker

  def perform(presentation_id)
    presentation = Presentation.find(presentation_id)
    presentation.update(status: 'cleaning_folder')

    folder_path = File.join(ENV['UPLOAD_FOLDER'], presentation.uploaded_file)

    if File.directory?(folder_path)
      FileUtils.rm_rf(folder_path)

      presentation.update(status: 'cleaned')
    else
      presentation.update(status: 'failed_to_clean')
    end
  end
end
