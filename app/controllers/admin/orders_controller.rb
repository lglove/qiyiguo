# -*- encoding : utf-8 -*-
class Admin::OrdersController < Admin::ApplicationController
  layout "admin"

  def index
    @admin_orders = Order.page(params[:page] ||1)
                         .where(["name like ? and mobilephone like ?", "%#{params[:name]}%", "%#{params[:mobilephone]}%"])
                         .order("id desc")
  end

  def new
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
      params.require(:order).permit(:name, :status, :express)
    end

end
