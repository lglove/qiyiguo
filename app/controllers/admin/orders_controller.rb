# -*- encoding : utf-8 -*-
class Admin::OrdersController < Admin::ApplicationController
  layout "admin"
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @admin_orders = Order.page(params[:page] ||1)
                         .where(["name like ?", "%#{params[:name]}%"])
                         .order("id desc")
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

  def destroy
    @order.destroy
    redirect_to action: "index"
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :price, :status, :express)
    end

end
