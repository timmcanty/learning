class TracksController < ApplicationController
  before_action :check_log_in

  def new
    @track = Track.new
    @album_id = params[:album_id]
    render :new
  end

  def create
    @track = Track.new( #refactor one line
    title: track_params[:title],
    lyrics: track_params[:lyrics],
    track_type: track_params[:track_type],
    album_id: track_params[:album_id]
    )

    if @track.save
      redirect_to album_url(@track.album_id)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :new
    end
  end

  def show
    @track = Track.find(params[:id])
    render :show
  end

  def destroy
    Track.destroy(params[:id])
    redirect_to bands_url
  end

  def edit
    @track = Track.find(params[:id]) #refactor after removed
    @album_id = @track.album_id
    render :edit
  end

  def update
    @track = Track.find(params[:id])
    if @track.update(track_params)
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :edit
    end
  end


  private

  def track_params
    params.require(:track).permit(:title, :lyrics, :track_type, :album_id)
  end

  
end
