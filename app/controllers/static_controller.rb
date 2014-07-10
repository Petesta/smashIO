class StaticController < ApplicationController
  def main
    return videos_path if signed_in?
  end

end
