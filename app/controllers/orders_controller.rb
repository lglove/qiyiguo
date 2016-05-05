class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => :h5_make_payment

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
    order = Order.new
    order.user_id = @user.id
    order.name = @user.name+"的果子"
    order.price = 500
    order.address = @user.userAddress.address
    if order.save
    render json: {code: "ok", text: "请付款", price: 500, order_id: order.id}
    else
    render json: {code: "false", text: "生成订单失败"}
    end
  end

  def make_payment
    payment = Payment.find_by_order_id(params[:order_id])
    payment = Payment.new if !payment
    payment.order_id = params[:order_id]
    payment.amount = 500
    payment.channel = 'alipay_qr'
    payment.currency = "cny"
    payment.client_ip = "127.0.0.1"

    payment.save

    order = Order.find(params[:order_id])

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

        render :text=>res
  end

  def h5_make_payment
    payment = Payment.find_by_order_id(params[:order_no])
    payment = Payment.new if !payment
    payment.order_id = params[:order_no]
    payment.amount = params[:amount]
    payment.channel = params[:channel]
    payment.status = params[:body]
    payment.currency = params[:currency] || "cny"
    payment.client_ip = params[:client_ip] || "127.0.0.1"

    payment.save


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

    render :text=>res
  end


  #ping++的回调网址
  def notify
    payment = Payment.find_by_order_id(params[:data][:object][:order_id])
    if params[:type] == "charge.successed"
      payment.status = 'paid'
      payment.paid_at = params[:created]
      payment.save

      order = Order.find(params[:data][:object][:order_id])
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
