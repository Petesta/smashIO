class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?, :login_user

  def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  def signed_in?
    current_user.present?
  end

  def must_be_logged_in
    redirect_to login_path if !signed_in?
  end

  def login_user(user)
    cookies[:auth_token] = user.auth_token
  end

end
