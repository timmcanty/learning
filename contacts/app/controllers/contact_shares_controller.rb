class ContactSharesController < ApplicationController

  def create
    @contact_share = ContactShare.new(share_params)
    render json: @contact_share
  end

  def destroy
    @contact_share = ContactShare.find(params[:id])
    if @contact_share.destroy
      render json: @contact_share
    else
      render json: @contact_share.errors.full_messages, status: :unprocessable_entity
    end
  end

  def favorite
    @contact_share = ContactShare.find(params[:id])
    @contact_share.toggle!(:favorite)
    render json: @contact_share
  end

  private

  def share_params
    params[:contact_share].permit(:contact_id, :user_id)
  end
end
