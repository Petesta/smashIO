class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:success] = "User successfully created!"
      login_user(@user)
      redirect_to videos_url
    else
      flash[:error] = "User wasn't successfully created!"
    end
  end

  def index
  end

  def list
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
