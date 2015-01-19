class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def login_user!(user)
    session[:token] = user.session_token
  end

  def logout_user!(user)
    session[:token] = nil
    user.reset_session_token!
  end

  def current_user
    User.find_by( session_token: session[:token])
  end

  def ensure_logged_in
    unless !!current_user
      redirect_to new_session_url
    end
  end

  helper_method :current_user
end
