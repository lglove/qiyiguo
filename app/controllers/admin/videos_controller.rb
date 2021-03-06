# -*- encoding : utf-8 -*-
class Admin::VideosController < Admin::ApplicationController
  layout "admin"
  before_action :set_video, only: [:show, :edit, :shanchu, :update, :destroy]

  def index
    @admin_videos = Admin::Video.page(params[:page] ||1)
                         .where(["name like ?", "%#{params[:name]}%"])
                         .order("id desc")
  end

  def shanchu
    @video.destroy
    respond_to do |format|
      format.html { redirect_to  :action=>'index', :page=>params[:page]}
      flash[:notice]= '删除了一条信息.'
    end
  end

  def new
    @video = Admin::Video.new
  end

  def edit
  end

  def create
    @video = Admin::Video.new(video_params)
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
      @video = Admin::Video.find(params[:id])
    end

    def video_params
      params.require(:admin_video).permit(:name,:logo,:url)
    end

end

