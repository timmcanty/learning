class SessionsController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by(username: params[:username] )
    if @user && @user.is_password?(params[:password])
      login_user!(@user)
      redirect_to subs_url
    else
      flash.now[:errors] = @users.errors.full_messages
      render :new
    end
  end

  def destroy
    @user = current_user
    logout_user!(@user)
    redirect_to new_session_url
  end
end
