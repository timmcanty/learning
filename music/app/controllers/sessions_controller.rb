class SessionsController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_email(user_params[:email])
    if @user.is_password?(user_params[:password])
      log_in_user!(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def destroy
    log_out_user!(current_user)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
