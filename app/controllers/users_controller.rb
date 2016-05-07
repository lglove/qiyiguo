class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:info, :body]

  def index
    @users = User.all
  end

  def show
  end

  def login
    user = User.find_by(["(name = ? or mobilephone = ?) and password = ?", params[:name], params[:name], User.md5(params[:password])])
    if user
      session[:user_id] = user.id
      redirect_to session[:old_url]
    else
      flash[:notice] = "账号或密码错误"
      redirect_to controller: "home", action: "register"
    end
  end

  def register
  end

  def logout
    session[:admin_user_id] = nil
    redirect_to action: "register"
  end

  def new
    @user = User.new
  end

  def edit
  end

  def info
    user = User.find(session[:user_id])
    user.name = params[:name] if params[:name].present?
    user.birthday = params[:date] if params[:date].present?
    user.password = User.md5(params[:password]) if params[:password].present?
    user.email = params[:email] if params[:email].present?
    user.mobilphone = params[:mobilphone] if params[:mobilphone].present?
    user.save
    address = UserAddress.find_by_user_id(user.id)
    if !address
      address = UserAddress.new
      address.user_id = user.id
    end
    params[:mail_address] = params[:shengshi]+params[:mail_address] if params[:shengshi].present?
    address.name = params[:mail_name] if params[:mail_name].present?
    address.address = params[:mail_address] if params[:mail_address].present?
    address.save

      redirect_to controller: "home", action: "personalAll"
  end

  def body
    bodyInfo = UserInfo.find_by_user_id(session[:user_id])
    if !bodyInfo
      bodyInfo = UserInfo.new
    end
    bodyInfo.user_id = session[:user_id]
    bodyInfo.height = params[:height] if params[:height].present?
    bodyInfo.weight = params[:weight] if params[:weight].present?
    bodyInfo.shangyiqima = params[:shangyiqima] if params[:shangyiqima].present?
    bodyInfo.yaowei = params[:yaowei] if params[:yaowei].present?
    bodyInfo.bichang = params[:bichang] if params[:bichang].present?
    bodyInfo.jiankuan = params[:jiankuan] if params[:jiankuan].present?
    bodyInfo.xiongwei = params[:xiongwei] if params[:xiongwei].present?
    bodyInfo.biwei = params[:biwei] if params[:biwei].present?
    bodyInfo.datuiwei = params[:datuiwei] if params[:datuiwei].present?
    bodyInfo.kuchang = params[:kuchang] if params[:kuchang].present?
    bodyInfo.xiema = params[:xiema] if params[:xiema].present?
    bodyInfo.save

    if params[:from]=="manner"
      redirect_to controller: "home", action: "manner_6"
    else
      redirect_to controller: "home", action: "personalAll"
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to action: "index", notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.fetch(:user, {})
    end
end
