class ProcessVideoWorker
  include Sidekiq::Worker

  def perform(presentation_id, folder_name)
    presentation = Presentation.find(presentation_id)
    presentation.update(status: 'processing')

    cwd_path = ENV['UPLOAD_FOLDER']
    result = `cd #{cwd_path} && ./multinorm.sh #{folder_name}`

    presentation.update(status: 'processed')
    UploadVideoWorker.perform_async(presentation_id, folder_name)
  end
end
