
class ApplicationController < ActionController::Base


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    return nil unless session[:user_token]
    @st ||=  UserSession.find_by_session_token(session[:user_token])
    return nil unless @st
    @cu ||= @st.user
  end

  def login_user!
    session[:user_token] = @user.random_session_token
    user_agent = UserAgentParser.parse(request.env['HTTP_USER_AGENT'])
    device  = user_agent.os.to_s
    browser = user_agent.family.to_s
    remote_ip = request.remote_ip
    search = Geocoder.search(remote_ip)
    location = "#{search[0].data["city"]}, #{search[0].data["country_code"]}"
    UserSession.create(user_id: @user.id, session_token: session[:user_token],
      device: device, browser: browser, location: location)
    redirect_to cats_url
  end

  def logout_user!(id)
    user_sess= UserSession.find(id)
    session[:user_token] = nil if user_sess.session_token == session[:user_token]
    user_sess.destroy unless user_sess.nil?
    redirect_to new_sessions_url
  end

  def ensure_user_logged_out
    redirect_to cats_url if current_user
  end

  def logged_in?
    !!current_user
  end

  def redirect_invalid_request
    redirect_to new_sessions_url unless logged_in?
  end

  helper_method :current_user
end
