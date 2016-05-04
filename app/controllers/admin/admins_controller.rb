# -*- encoding : utf-8 -*-
class Admin::AdminsController < Admin::ApplicationController
  layout "admin"
  before_action :set_admin_user, only: [:show, :edit, :update, :destroy]

  def index
    @admin_users = Admin.page(params[:page] || 1).
                   where("email like ? and name like ?", "%#{params[:email]}%","%#{params[:name]}%").
                   order("id asc")
  end

  def update_password
    if params[:password1] != params[:password2] || params[:password1].to_s.size == 0
      flash[:notice] = "修改失败，请检查两次输入是否一致"
    else
      @admin_user.password = Admin.md5(params[:password1])
      @admin_user.save
      flash[:notice] = "修改成功"
    end

    redirect_to action: "change_password"
  end

  def rights
    @admin = Admin.find(params[:id])
  end

  def set_right
    admin = Admin.find(params[:id]);
    admin.menu_ids = params[:menu_ids]
    flash[:notice] = "设置成功"
    redirect_to action: "index"
  end

  def change_password
  end

  def show
  end

  def new
    @admin_user = Admin.new
  end

  def edit
    @admin_user = Admin.find(params[:id])
  end

  def create
    admin_params = admin_user_params
    admin_params["password"] = Admin.md5(admin_params["password"])
    @admin_user = Admin.new(admin_params)

    respond_to do |format|
      if @admin_user.save
        format.html { redirect_to :action=>'index', :page=>params[:page]}
        flash[:notice] = '成功创建用户.'
      else
        format.html { render :new }
      end
    end
  end

  def update
    admin_params = admin_user_params
    admin_params["password"] = Admin.md5(admin_params["password"])
    respond_to do |format|
      if @admin_user.update(admin_params)
        format.html { redirect_to :action=>'index', :page=>params[:page] }
        flash[:notice] = '成功更新用户.'
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @admin_user.destroy
    respond_to do |format|
      format.html { redirect_to  :action=>'index', :page=>params[:page]}
      flash[:notice]= '删除了一条用户信息.'
    end
  end

  private
    def set_admin_user
      @admin_user = Admin.find(params[:id])
    end

    def admin_user_params
      params.require(:admin).permit(:email, :password,  :name)
    end
end
