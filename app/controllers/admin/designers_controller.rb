# -*- encoding : utf-8 -*-
class Admin::DesignersController < Admin::ApplicationController
  layout "admin"
  before_action :set_designer, only: [:show, :edit,:shanchu, :update, :destroy]

  def index
    @admin_designers = Designer.page(params[:page] ||1)
                         .where(["name like ?", "%#{params[:name]}%"])
                         .order("id")
  end

  def shanchu
    @designer.destroy
    respond_to do |format|
      format.html { redirect_to  :action=>'index', :page=>params[:page]}
      flash[:notice]= '删除了一条信息.'
    end
  end

  def new
    @designer = Designer.new
  end

  def edit
  end

  def create
    @designer = Designer.new(designer_params)
    if @designer.save
      redirect_to action: "index"
    end
  end

  def update
    if @designer.update(designer_params)
      redirect_to action: "index"
    end
  end

  def destroy
    @designer.destroy
    redirect_to action: "index"
  end

  private
    def set_designer
      @designer = Designer.find(params[:id])
    end

    def designer_params
      params.require(:designer).permit(:name, :sex, :email,:logo, :mobilephone, :description)
    end

end
