class UsersController < ApplicationController

  before_action :ensure_user_logged_out, only: [:new]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_name: user_params[:user_name])
    @user.password = user_params[:password]
    if @user.save
      login_user!
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name,:password)
  end

end
