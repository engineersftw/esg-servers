class ProcessVideoWorker
  include Sidekiq::Worker

  def perform(presentation_id)
    presentation = Presentation.find(presentation_id)
    presentation.update(status: 'processing')

    folder_name = presentation.uploaded_file

    cwd_path = ENV['UPLOAD_FOLDER']
    result = `cd #{cwd_path} && ./multinorm.sh #{folder_name}`

    file_path = File.join(ENV['UPLOAD_FOLDER'], folder_name, 'normalized', "#{folder_name}-norm.mp4")

    if File.file?(file_path)
      presentation.update(status: 'processed')
      UploadVideoWorker.perform_async(presentation_id)
    else
      presentation.update(status: 'failed_to_process')
    end
  end
end
