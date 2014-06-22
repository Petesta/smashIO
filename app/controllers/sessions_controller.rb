class SessionsController < ApplicationController
  def new
    redirect_to root_url if signed_in?
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      login_user(user)
      redirect_to videos_path
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to users_path
  end

end
