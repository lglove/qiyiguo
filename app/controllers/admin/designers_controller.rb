# -*- encoding : utf-8 -*-
class Admin::DesignersController < Admin::ApplicationController
  layout "admin"

  def index
    @admin_designers = Designer.page(params[:page] ||1)
                         .where(["name like ? and mobilephone like ?", "%#{params[:name]}%", "%#{params[:mobilephone]}%"])
                         .order("id desc")
  end

  def new
  end

  def edit
  end

  def create
    designer_params["password"] = Admin.md5("#{designer_params["password"]}")
    @designer = Designer.new(designer_params)
    if @designer.save
      redirect_to action: "index"
    end
  end

  def update
    designer_params["password"] = Admin.md5("#{designer_params["password"]}")
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
      params.require(:designer).permit(:name, :email, :password, :mobilephone, :description)
    end

end
