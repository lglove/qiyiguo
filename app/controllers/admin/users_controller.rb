# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::ApplicationController
  layout "admin"
  before_action :set_user, only: [:show, :edit,:shanchu, :update, :destroy]

  def index
    @users= User.page(params[:page] || 1).where("email like ? and name like ?", "%#{params[:email]}%","%#{params[:name]}%").order("id")
  end

  def update_password
    if params[:password1] != params[:password2] || params[:password1].to_s.size == 0
      flash[:notice] = "修改失败，请检查两次输入是否一致"
    else
      @user.password = User.md5(params[:password1])
      @user.save
      flash[:notice] = "修改成功"
    end

    redirect_to action: "change_password"
  end


  def change_password
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
    @admin_user = User.find(params[:id])
  end

  def create
    admin_params = admin_user_params
    admin_params["password"] = User.md5("888888888")
    @user = User.new(admin_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to :action=>'index', :page=>params[:page]}
        flash[:notice] = '成功创建用户.'
      else
        format.html { render :new }
      end
    end
  end

  def update
    admin_params = admin_user_params
    respond_to do |format|
      if @user.update(admin_params)
        format.html { redirect_to :action=>'index', :page=>params[:page] }
        flash[:notice] = '成功更新用户.'
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to  :action=>'index', :page=>params[:page]}
      flash[:notice]= '删除了一条用户信息.'
    end
  end

  def shanchu
    @user.destroy
    respond_to do |format|
      format.html { redirect_to  :action=>'index', :page=>params[:page]}
      flash[:notice]= '删除了一条用户信息.'
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def admin_user_params
      params.require(:user).permit(:mobilephone, :password,  :name, :email)
    end
end

