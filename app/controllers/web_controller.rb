class WebController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_login, :except => ["login", "signin", "logout"]
  before_filter :get_login_user

  def check_login
    if session[:admin_user_id].nil?
      flash[:notice] = "请先登录"
      redirect_to :controller => 'admin/main', :action => 'login'
    end
  end

  def get_login_user
  	if session[:admin_user_id]
  		@admin_user= Admin::Admin.find(session[:admin_user_id])
  	end
  end
end

