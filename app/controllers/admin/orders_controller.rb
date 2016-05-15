# -*- encoding : utf-8 -*-
class Admin::OrdersController < Admin::ApplicationController
  layout "admin"
  before_action :set_order, only: [:lianxi, :fahuo, :wancheng, :zhanshi, :edit,:shanchu, :update, :destroy]

  def index
    @admin_orders = Order.page(params[:page] ||1)
                         .where(["name like ?", "%#{params[:name]}%"])
                         .order("id desc")
  end

  def shanchu
    @order.destroy
    respond_to do |format|
      format.html { redirect_to  :action=>'index', :page=>params[:page]}
      flash[:notice]= '删除了一条信息.'
    end
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to action: "index"
    end
  end

  def update
    if @order.update(order_params)
      redirect_to action: "index"
    end
  end

  def zhanshi
    @user = @order.user
    @body = @user.userInfo
    @style = @user.userStyle
    puts @style.inspect
    @designer = @order.designer
  end

  def user_amount
    @user =  User.find(params[:id])
    @user.amount = params[:value].to_i
    @user.save
    render text: params[:value]
  end

  def month_amount
    @user =  User.find(params[:id])
    @user.month_amount = params[:value].to_i
    @user.save
    render text: params[:value]
  end

  def invite_amount
    @user =  User.find(params[:id])
    @user.invite_amount = params[:value].to_i
    @user.save
    render text: params[:value]
  end

  def destroy
    @order.destroy
    redirect_to action: "index"
  end

  def lianxi
    if @order.paid == "已支付"
      @order.paid = "已联系"
      to_index
    else
      flash[:notice] = "该订单尚未支付"
      to_index
    end
  end

  def fahuo
    if @order.paid == "已联系"
      @order.paid = "已发货"
      to_index
    else
      flash[:notice] = "该订单尚未联系"
      to_index
    end
  end

  def wancheng
    if @order.paid == "已发货"
      @order.paid = "已完成"
      to_index
    else
      flash[:notice] = "该订单尚未发货"
      to_index
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :price, :status, :express)
    end

    def to_index
      redirect_to :action=>"index", :page=>params[:page], :anchor=>params[:id]
      return;
    end

end
