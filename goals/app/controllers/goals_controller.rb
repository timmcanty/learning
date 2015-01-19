class GoalsController < ApplicationController

  def index
    @all_goals = Goal.all.includes(:author)
    render :index
  end

  def new
    @goal = Goal.new
    render :new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.author_id = current_user.id
    if @goal.save
      redirect_to goals_url
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy!
    redirect_to goals_url
  end

  def edit
    @goal = Goal.find(params[:id])
    render :edit
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update(goal_params)
      redirect_to goals_url
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:content, :public, :complete)
  end
end
