class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by(:username => user_params[:username])
    return nil if @user.nil?
    if @user.is_password?(user_params[:password])
      log_in(@user)
      redirect_to goals_url
    else
      flash.now[:errors] << @user.errors.full_messages
      render :new
    end
  end

  def destroy
    @user = current_user
    log_out(@user)
    redirect_to new_session_url
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
