class PresentationsController < ApplicationController
  before_action :display_status, if: -> { params[:status].present? }

  def index
    @presentations = Presentation.where(active: true).order('presented_at ASC')
  end

  def new
    if params[:duplicate_from].present?
      @presentation = Presentation.find(params[:duplicate_from])
    else
      @presentation = Presentation.new(
          description: "Speaker: \n\nEvent Page: \n\nProduced by Engineers.SG",
          presented_at: Date.today
      )
    end
  end

  def create
    if params[:presentation_id].present?
      @presentation = Presentation.find(params[:presentation_id])
    else
      @presentation = Presentation.create(presentation_params)
    end

    if params[:file].present?
      saved_file_path, md5_filename = move_uploaded_file(file_params)

      if saved_file_path.present? && File.exist?(saved_file_path)
        @presentation.update(status: 'uploaded', uploaded_file: md5_filename)

        Rails.logger.info "Adding ProcessVideoWorker for #{saved_file_path}"
        ProcessVideoWorker.perform_async(@presentation.id)
      end
    end

    render json: {status: 'success'}
  end

  def destroy
    presentation = Presentation.find(params[:id])
    presentation.update(active: false)

    redirect_to root_path, notice: "\"#{presentation.title}\" was marked as hidden."
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
