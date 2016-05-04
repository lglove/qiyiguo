# -*- encoding : utf-8 -*-
class Admin::VideosController < Admin::ApplicationController
  layout "admin"

  def index
    @admin_videos = Video.page(params[:page] ||1)
                         .where(["name like ? and mobilephone like ?", "%#{params[:name]}%", "%#{params[:mobilephone]}%"])
                         .order("id desc")
  end

  def new
  end

  def edit
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      redirect_to action: "index"
    end
  end

  def update
    if @video.update(video_params)
      redirect_to action: "index"
    end
  end

  def destroy
    @video.destroy
    redirect_to action: "index"
  end

  private
    def set_video
      @video = Video.find(params[:id])
    end

    def video_params
      params.require(:video).permit(:name, :url)
    end

end

