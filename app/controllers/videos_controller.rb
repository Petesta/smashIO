class VideosController < ApplicationController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(params[:video])
    @video.user_id = current_user.id

    if @video.save
      flash[:success] = "Video successfully uploaded!"
      redirect_to users_url
    else
      flash[:error] = "Video wasn't successfully uploaded!"
      render 'new'
    end
  end

  def index
    @videos = Video.order('created_at DESC')
  end

  def show
  end

  def list
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
