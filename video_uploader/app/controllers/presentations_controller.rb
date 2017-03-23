class PresentationsController < ApplicationController
  before_action :authenticate_admin!
  before_action :fetch_presentation, only: [:destroy, :edit, :update]
  # before_action :fetch_esg_data, only: [:new, :edit]
  before_action :fetch_playlists, only: [:new]

  def index
    @current_page = (params[:page] || 1).to_i
    @presentations = Presentation.active.order('created_at DESC').page(@current_page)
    @total_records = @presentations.total_count
  end

  def search
    @search = search_param[:search]
    @presented_at = search_param[:presented_at]
    @presentations = []

    if @search.present? || @presented_at.present?
      @presentations = Presentation.active.order('presented_at DESC')
      @presentations = @presentations.where('lower(title) like :term or lower(description) like :term', {term: "%#{@search.downcase}%"}) if @search.present?
      @presentations = @presentations.where(presented_at: @presented_at) if @presented_at.present?
    end
  end

  def new
    @presentation = Presentation.new(
        description: "Speaker: \n\nEvent Page: \n\nProduced by Engineers.SG",
        presented_at: Date.today,
        playlist_id: ENV['DEFAULT_PLAYLIST_ID']
    )

    if params[:event_id].present?
      @event = Event.find(params[:event_id])

      @presentation.event = @event
      @presentation.title = @event.title
      @presentation.description = @event.description
      @presentation.presented_at = @event.event_date
    end
  end

  def create
    if params[:presentation_id].present?
      @presentation = Presentation.find(params[:presentation_id])
    else
      @presentation = Presentation.create(presentation_params)
    end

    unless @presentation.valid?
      return render json: {status: 'failed_to_save', error: @presentation.errors.full_messages.join('. ')}, status: 500
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
    @presentation.update(active: false)

    redirect_to presentations_path, notice: "\"#{@presentation.title}\" was marked as hidden."
  end

  def update
    @presentation.update(presentation_params)

    if @presentation.valid?
      update_youtube_details_for(@presentation) if (@presentation.has_video_link?)

      redirect_to presentations_path, notice: "\"#{@presentation.title}\" was updated."
    else
      flash.now[:error] = 'Unable to update this presentation: ' + @presentation.errors.messages
      render :edit
    end
  end

  private

  def presentation_params
    params.permit(:title, :description, :presented_at, :event_id, :playlist_id, :presenters, :organizations)
  end

  def file_params
    params.require(:file)
  end

  def search_param
    params.permit(:search, :presented_at)
  end

  def move_uploaded_file(uploaded_file={})
    return if uploaded_file == nil

    if uploaded_file.try(:original_filename)
      md5_filename = Digest::MD5.hexdigest("#{uploaded_file.original_filename}-#{Time.now.to_i}")
      file_ext = File.extname(uploaded_file.original_filename)
      temp_file = uploaded_file.tempfile
    else
      md5_filename = Digest::MD5.hexdigest("#{uploaded_file[:original_filename]}-#{Time.now.to_i}")
      file_ext = File.extname(uploaded_file[:original_filename])
      temp_file = uploaded_file[:tempfile]
    end

    save_path = File.join(ENV['UPLOAD_FOLDER'], md5_filename, md5_filename + file_ext)

    dir = File.dirname(save_path.to_s)
    FileUtils.mkdir_p(dir, mode: 0777) unless File.directory?(dir)

    if File.exist?(temp_file)
      Rails.logger.info "Copying #{temp_file} to #{save_path}..."
      FileUtils.mv(temp_file, save_path)

      [save_path, md5_filename]
    end
  end

  def fetch_presentation
    @presentation ||= Presentation.find(params[:id])
  end

  def fetch_playlists
    @playlists ||= Playlist.active.order('title ASC')
  end

  def fetch_esg_data
    esg_service = EsgService.new
    @organizations ||= esg_service.organizations
    @presenters ||= esg_service.presenters
  end

  def update_youtube_details_for(presentation)
    begin
      youtube_service = YoutubeService.new
      options = {
          id: presentation.video_id,
          title: presentation.title,
          description: presentation.description,
      }
      api_response = youtube_service.update_video(options)

      Rails.logger.info("Video id '#{api_response.try(:data).try(:id)}' was successfully updated.")
    rescue => e
      Rails.logger.error("Failed to update YouTube (#{presentation.video_id}): #{e.message}")
    end
  end
end
