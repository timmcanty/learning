class CatRentalRequestsController < ApplicationController
  before_action :redirect_invalid_request, only: [:new, :create, :approve, :deny]
  before_action :is_users_cat?, only: [:approve, :deny]


  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    @cat_rental_request.user_id = current_user.id
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :new
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.approve
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])
    @cat_rental_request.deny
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

  def is_users_cat?
    request = CatRentalRequest.find(params[:id])
    cat = request.cat
    unless cat.user_id == current_user.id
      redirect_to cats_url
    end
  end

end
