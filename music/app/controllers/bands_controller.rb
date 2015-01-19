class BandsController < ApplicationController
  before_action :check_log_in

  def index
    render :index
  end

  def new
    @band = Band.new
    render :new
  end

  def show
    @band = Band.find(params[:id])
    render :show
  end

  def create
    @band = Band.new(name: band_params[:name])
    if @band.save
      redirect_to bands_url
    else
      flash.now[:errors] = @band.errors.full_messages
      render :new
    end
  end

  def destroy
    Band.destroy(params[:id])
    redirect_to bands_url
  end

  def edit
    @band = Band.find(params[:id])
    render :edit
  end

  def update
    @band = Band.find(params[:id])
    if @band.update(band_params)
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors.full_messages
      render :edit
    end
  end


  private

  def band_params
    params.require(:band).permit(:name)
  end
end
