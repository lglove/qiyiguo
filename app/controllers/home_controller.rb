class HomeController < ApplicationController
  layout "home"
  SMS_URL = "http://yunpian.com/v1/sms/tpl_send.json"

  before_filter :check_login, :only => ["manner_1","personalAll"]
  before_filter :get_login_user
  protect_from_forgery :except => ["mobile_register","password_update"]

  def index
    render :layout=>false
  end

  def designer
    @designers = Designer.all
  end

  def designervideo
    @video = Admin::Video.all
  end

  def video
    @video = Admin::Video.find(params[:id])
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

  def update_manner
      userStyle = UserStyle.find_by_user_id(@user.id)
    if params[:style]
      userStyle.update(style: params[:style])
    end
    if params[:fuse]
      userStyle.update(fuse: params[:fuse])
    end
    if params[:kangju]
      userStyle.update(kangju: params[:kangju])
    end
    if params[:shencai]
      userStyle.update(shencai: params[:shencai])
    end
    render :json=>{code: 0}
  end

  def update_body
    body = UserInfo.find_by_user_id(@user.id)
    body.update(height: params[:height],
                weight: params[:weight],
                shangyichima: params[:shangyichima],
                yaowei: params[:yaowei],
                bichang: params[:bichang],
                jiankuan: params[:jiankuan],
                xiongwei: params[:xiongwei],
                biwei: params[:biwei],
                datuiwei: params[:datuiwei],
                kuchang: params[:kuchang],
                xiema:params[:xiema])
    render :json=> {code:0}
  end

  def personal
  end

  def personalAll
    @user = User.find(session[:user_id])
    if params[:designer_id]
      @user.designer_id = params[:designer_id]
      @user.save
    end
    @address = UserAddress.find_by_user_id(@user.id)
    @wanzheng = false
    if @user.name.present? && @user.mobilephone.present? && @address.name.present? && @address.address.present?
      @wanzheng = true
    end
  end

  def political
  end

  def serve
  end

  def order_validate
    order = Order.where("user_id = '#{@user.id}'").last
    puts order.inspect
    if order && order.paid == "待付款"
      render :json=>{code: 1}
    else
      render :json=>{code: 0}
    end
  end

  def use
  end

  def welcome
  end

  def register
  end

  def mobile_validate
    v = MobileValidate.new
    v.mobile = params[:mobile]
    v.code = rand(1000..10000)
    v.checked = 0
    v.save

#    RestClient.post SMS_URL, apikey: "2ce832e429d73c821b3ad2b954b92bae", mobile: params[:mobile], tpl_id: 1380861, tpl_value: "#code#=#{v.code}"
    flash.now[:notice] = "验证码已发送，请在手机上查看"
    render :text=>"ok"
  end

  def password_update
    v = MobileValidate.find_by(["mobile = ? and code = ? and checked = 0", params[:mobilephone], params[:code]])
    user = User.find_by(["(name = ? or mobilephone = ?)", params[:mobilephone], params[:mobilephone]])
    if v
       user.password=User.md5(params[:password])
       user.save
       v.checked = "1"
       v.save
      flash.now[:notice] = "密码修改成功"
      session[:user_id] = user.id
      redirect_to params[:designer] == "designer" ? "/designer" : "/personalAll?from=welcome"
    else
      flash[:notice] = "验证码错误"
      redirect_to "/home/forgetpassword"
    end
  end

  def forgetpassword
  end

  def mobile_register
    user = User.find_by(["(name = ? or mobilephone = ?)", params[:mobilephone], params[:mobilephone]])
    v = MobileValidate.find_by(["mobile = ? and code = ? and checked = 0", params[:mobilephone], params[:code]])
    if !user && v
      puts user.inspect
      user = User.new
      user.name = params[:mobilephone]
      user.mobilephone = params[:mobilephone]
      user.password = User.md5(params[:password])
      user.invitecode = "qiyi"+params[:mobilephone]
      user.save
      v.checked = "1"
      if user && params[:invitecode].present?
        invite_user = User.find_by("invitecode = ?", params[:invitecode])
        invite_user.invite_amount += 20
        invite_user.save
        user.update(invite_id: invite_user.id)
      end
      UserAddress.create(user_id: user.id)
      UserInfo.create(user_id: user.id)
      UserStyle.create(user_id: user.id)

      session[:user_id] = user.id
      redirect_to params[:designer] == "designer" ? "/designer" : "/personalAll?from=welcome"
    else
      flash[:notice] = "该手机号已经注册"
      redirect_to action: "register", from: "register", designer: params[:designer]
    end

  end

  def signin
    user = User.find_by(["(name = ? or mobilephone = ?) and password = ?", params[:mobilephone], params[:mobilephone], User.md5(params[:password])])
    if user.present?
      session[:user_id] = user.id
      redirect_to params[:designer] == "designer" ? "/designer" : "/personalAll"
    else
      flash[:notice] = "账号或密码错误"
      redirect_to action: "register", from: params[:from], designer: params[:designer]
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
      redirect_to action: "register", from: params[:from], designer: params[:designer]
    end
  end

  def get_login_user
  	if session[:user_id]
  		@user= User.find(session[:user_id])
  	end
  end

end
