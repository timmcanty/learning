class SessionsController < ApplicationController

  before_action :ensure_user_logged_out, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_user_name(session_params[:user_name])
    redirect_to new_sessions_url if @user.nil?
    if @user.is_password?(session_params[:password])
      login_user!
    else
      render :new
    end

  end

  def destroy
    logout_user!(params[:destroy][:id])
  end

  private

  def session_params
    params.require(:user).permit(:user_name, :password)
  end

end
