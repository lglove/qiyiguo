# -*- encoding : utf-8 -*-
class Admin::MainController < Admin::ApplicationController
  layout "admin"
  def index
  	redirect_to action: "welcome"
  end

  def welcome
  end

  def login
  end

  def logout
    session[:admin_user_id] = nil
    redirect_to action: "login"
  end

  def signin
    user = Admin.find_by(["(name = ? or email = ?) and password = ?", params[:name], params[:email], Admin::Admin.md5(params[:password])])
    if user
      session[:admin_user_id] = user.id
      redirect_to action: "welcome"
    else
      flash[:notice] = "账号或密码错误"
      redirect_to action: "login"
    end
  end
end
