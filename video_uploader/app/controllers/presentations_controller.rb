class PresentationsController < ApplicationController
  before_action :display_status, if: -> { params[:status].present? }

  def index
    @presentations = Presentation.where(active: true).order('presented_at ASC')
  end

  def new
    @presentation = Presentation.new(
                                    description: "Speaker: \n\nEvent Page: \n\nProduced by Engineers.SG",
                                    presented_at: Date.today
    )
  end

  def create
    if params[:presentation_id].present?
      @presentation = Presentation.find(params[:presentation_id])
    else
      @presentation = Presentation.create(presentation_params)
    end

    saved_file_path, md5_filename = move_uploaded_file(file_params)

    if saved_file_path.present? && File.exist?(saved_file_path)
      @presentation.update(status: 'uploaded')

      Rails.logger.info "Adding ProcessVideoWorker for #{saved_file_path}"
      job_id = ProcessVideoWorker.perform_async(@presentation.id, md5_filename)
    end

    render json: {status: 'success', file: saved_file_path, new_queue: job_id}
  end

  private

  def display_status
    status = params[:status].to_sym
    flash.now[status] = params[:message]
  end

  def presentation_params
    params.permit(:title, :description, :presented_at)
  end

  def file_params
    params.require(:file).permit(:original_filename, :tempfile, :content_type, :size)
  end

  def move_uploaded_file(uploaded_file={})
    return if uploaded_file.empty?

    md5_filename = Digest::MD5.hexdigest("#{uploaded_file[:original_filename]}-#{Time.now.to_i}")
    file_ext = File.extname(uploaded_file[:original_filename])

    save_path = File.join(ENV['UPLOAD_FOLDER'], md5_filename, md5_filename + file_ext)

    dir = File.dirname(save_path.to_s)
    FileUtils.mkdir_p(dir, mode: 0777) unless File.directory?(dir)

    if File.exist?(uploaded_file[:tempfile])
      Rails.logger.info "Copying #{uploaded_file[:tempfile]} to #{save_path}..."
      FileUtils.mv(uploaded_file[:tempfile], save_path)

      [save_path, md5_filename]
    end
  end
end
