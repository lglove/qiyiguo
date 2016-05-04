class HomeController < ApplicationController
  layout "home"

  before_filter :check_login, :only => ["manner_1","personalAll"]
  before_filter :get_login_user
  protect_from_forgery :except => :mobile_register

  def index
  end

  def designer
  end

  def designervideo
  end

  def explain
  end

  def manner_1
  end

  def manner_2
  end

  def manner_3
  end

  def manner_4
  end

  def manner_5
  end

  def manner_6
  end

  def personal
  end

  def personalAll
    @user = User.find(session[:user_id])
    @address = UserAddress.find_by_user_id(@user.id)
  end

  def political
  end

  def serve
  end

  def use
  end

  def welcome
  end

  def register
  end

  def mobile_register
    user = User.find_by(["(name = ? or mobilephone = ?)", params[:mobilephone], params[:mobilephone]])
    if !user
      puts user.inspect
      user = User.new
      user.mobilephone = params[:mobilephone]
      user.password = User.md5(params[:password])
      user.invitecode = "qiyi"+params[:mobilephone]
      user.save
      if user && params[:invitecode].present?
        invite_user = User.find_by("invitecode = ?", params[:invitecode])
        invite_user.invite_amount += 20
        invite_user.save
      end
      user.update(invite_id: invite_user.id)
      UserAddress.create(user_id: user.id)
      UserInfo.create(user_id: user.id)

      session[:user_id] = user.id
      redirect_to action: "welcome"
    else
      flash[:notice] = "该手机号已经注册"
      redirect_to action: "register"
    end

  end

  def signin
    user = User.find_by(["(name = ? or mobilephone = ?) and password = ?", params[:mobilephone], params[:mobilephone], User.md5(params[:password])])
    if user.present?
      session[:user_id] = user.id
      redirect_to action: "welcome"
    else
      flash[:notice] = "账号或密码错误"
      redirect_to action: "register"
    end
  end


  def signout
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def check_login
    if session[:user_id].nil?
      flash[:notice] = "请先登录"
      redirect_to :action=>'register'
    end
  end

  def get_login_user
  	if session[:user_id]
  		@user= User.find(session[:user_id])
  	end
  end

end
