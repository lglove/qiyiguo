class HomeController < ApplicationController
  #layout "home"
  SMS_URL = "http://yunpian.com/v1/sms/tpl_send.json"

  before_filter :check_login, :only => ["manner_1","personalAll"]
  before_filter :get_login_user
  protect_from_forgery :except => :mobile_register

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

  def use
    if params[:order] == "yes"
      @order = Order.find_by_user_id(2)
      unless @order
        @order = Order.new
        @order.user_id = 2
        @order.name = "测试的果子"
        @order.price = 500
        @order.address = "呼家楼"
        @order.save
      end
    end
  end

  def welcome
  end

  def register
  end

  def mobile_validate
    v = MobileValidate.new
    v.mobile = params[:mobile]
    v.code = rand(1000..10000)
    v.save

    RestClient.post SMS_URL, apikey: "cf1879047c9216b64e5a233eceee0d79", mobile: params[:mobile], tpl_id: 771157, tpl_value: "#code#=#{v.code}"

    render :text=>"ok"
  end

  def mobile_register
    user = User.find_by(["(name = ? or mobilephone = ?)", params[:mobilephone], params[:mobilephone]])
    if !user
      puts user.inspect
      user = User.new
      user.name = params[:mobilephone]
      user.mobilephone = params[:mobilephone]
      user.password = User.md5(params[:password])
      user.invitecode = "qiyi"+params[:mobilephone]
      user.save
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
      redirect_to action: "register", from: params[:from], designer: params[:designer]
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
