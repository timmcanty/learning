class CatsController < ApplicationController
  before_action :redirect_invalid_request, only: [:edit, :update, :new, :create]
  before_action :is_users_cat?, only: [:edit, :update]


  def index
    @cats = Cat.all

    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @rental_requests = @cat.rental_requests.order(:start_date)

    render :show
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def new
    @cat = Cat.new
    render :new
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:name,:birth_date,:sex,:color,:description)
  end

  def is_users_cat?
    unless Cat.find(params[:id]).user_id == current_user.id
      redirect_to cats_url
    end
  end

end
