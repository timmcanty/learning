class UsersController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user!(@user)
      render json: @user
    else
      flash[:error] = @user.errors.full_messages
      render :new
    end
  end


  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
