class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_login, :expect => [ "register", "notify", "index","desigervideo", "explain", "politial", "serve", "use", "mobile_register"]
  before_filter :get_login_user, :expect => [ "register","notify","index","desigervideo", "explain", "politial", "serve", "use", "mobile_register"]


  def check_login
    if session[:user_id].nil?
      flash[:notice] = "请先登录"
      redirect_to :action=>'register', :controller=>"/home"
    end
  end

  def get_login_user
  	if session[:user_id]
  		@user= User.find(session[:user_id])
  	end
  end
end
