class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:h5_make_payment, :make_payment]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def make_order
    order = User.find(params[:id]).orders.last
    if order && order.paid != "已支付"
      flash[:notice] = "你有尚未支付的果子"
    else
    order = Order.new
    order.user_id = @user.id
    order.order_number = Time.now + @user.id
    order.name = @user.name+"的果子"
    order.price = 500
    order.address = @user.userAddress.address
    if order.save
    render json: {code: "ok", text: "请付款", price: 500, order_id: order.id}
    else
    render json: {code: "false", text: "生成订单失败"}
    end
    end
  end

  def cancel_order
    order = User.find(params[:id]).orders.last
    order.destroy
    redirect_to controller: "home", action: "personalAll"
  end

  def make_payment
    @user = User.find(params[:id])
    #order = Order.find_by_user_id(@user.id)
    order = @user.orders.last
    puts "order#{order.inspect}"
    if order && order.paid != "已支付"
      flash[:notice]="您有尚未支付的果子"
      render json: {code: "false", text: "生成订单失败"}
    else
      order = Order.new
      order.user_id = @user.id || 2
      order.name = @user.name+"的果子" || "cehsi"
      order.price = 500
      #order.address = @user.userAddress.to_ary[0]["address"] || "decjiai"
      order.address = "decji"
      puts "创建订单"
      if order.save
        payment = Payment.find_by_order_id(order.id)
        payment = Payment.new if !payment
        payment.order_id = order.id
        payment.amount = 500
        payment.channel = 'alipay_qr'
        payment.currency = "cny"
        payment.client_ip = "127.0.0.1"

        payment.save

        order = Order.find(order.id)

        res = Pingpp::Charge.create(
          :order_no => payment.order_id,
          :amount   => payment.amount.to_i*100, #以分为单位
          :subject  => order.name,
          :body     => "#{order.user.name}奇衣果定金",
          :channel  => payment.channel,
          :currency => payment.currency,
          :client_ip=> payment.client_ip,
          :app => {:id => "app_GS4SSCKebTCSfTGu"}
        )
        puts "ppp#{res}"
        puts res["credential"]["alipay_qr"]
        render json: {data: res["credential"]["alipay_qr"]}
      else
        render json: {code: "false", text: "生成订单失败"}
      end
    end
  end

  def payment
    render :layout=>false
  end

  def h5_make_payment
    payment = Payment.find_by_order_id(params[:order_no])
    payment = Payment.new if !payment
    payment.order_id = params[:order_no]
    payment.amount = 500
    payment.channel = params[:channel]
    payment.status = params[:body]
    payment.result_url = params[:result_url]
    payment.success_url = params[:success_url]
    payment.cancel_url = params[:cancel_url]
    payment.currency = params[:currency] || "cny"
    payment.client_ip = params[:client_ip] || "127.0.0.1"

    payment.save


    #res = Pingpp::Charge.create(
    #  :order_no => payment.order_id,
    #  :amount   => payment.amount.to_i*100, #以分为单位
    #  :subject  => "order.name",
    #  :body     => "奇衣果定金",
    #  :channel  => payment.channel,
    #  :currency => payment.currency,
    #  :client_ip=> payment.client_ip,
    #  :app => {:id => "app_GS4SSCKebTCSfTGu"},
    #  :extra =>{:success_url=> payment.success_url, :cancel_url=>payment.cancel_url}
    #)

    puts "=======#{res.inspect}"
    #render :json=>res
    render :json=>"ok"
  end


  #ping++的回调网址
  def notify
    payment = Payment.find_by_order_id(params[:data][:object][:order_id])
    if params[:type] == "charge.successed"
      payment.status = 'paid'
      payment.paid_at = params[:created]
      payment.save

      order = Order.find(params[:data][:object][:order_id])
      order.paid = "paid"
      order.status = "待发货"
      order.save
    end
    render :text=>"ok"
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :user_id, :price)
    end
end
