# -*- encoding : utf-8 -*-
class Api::FulisheController < Api::ApplicationController
	before_filter :get_user, :only=>[:make_order, :my_orders, :receive_order, :make_comment, :delete_order]

	def list
		products = Admin::AProduct.page(params[:page]||1).per(params[:count]).where(["hide = 0"]).order("position asc, id desc")
		render json: products.to_json(include: "a_product_logos")
	end

	def get_comment
		comments = Admin::AComment.where(["a_product_id = ?", params[:product_id]]).order("id desc").limit(5)
		count = Admin::AComment.where(["a_product_id = ?", params[:product_id]]).count
		if count > 0
			star = (Admin::AComment.sum(:star, :conditions=>["a_product_id = ?", params[:product_id]])*1.0/count).round
		else 
			star = 5
		end
		render :json=>{:count=>count, :comments=>comments, :star=>star}
	end

	def make_order
		if false && !params[:id]	#新订单
			if Admin::AOrder.find_by(["user_id = ?", @user.id])
				render json: {code: -1, text: "对不起，福利社商品一人限兑换一件！"}
				return
			end
		end

		if !params[:id]  #新订单
			if Admin::AOrder.where(["user_id = ? and product_id = ?", @user.id, params[:product_id]]).count > 0
				render json: {code: -1, text: "对不起，福利社商品一人限兑换一件！"}
				return
			end
		end

		order = Admin::AOrder.find(params[:id]) if params[:id]
		order = Admin::AOrder.new if !order
		order.product_id = params[:product_id]
		order.model = params[:_model]
		order.pay_method = params[:pay_method]
		order.province_id = params[:province_id]
		order.city 		= params[:city]
		order.city_id 	= params[:city_id]
		order.address 	= params[:address]
		order.receiver 	= params[:receiver]
		order.mobile   	= params[:telephone]
		order.remark	= params[:remark]
		order.price 	= order.a_product.price
		order.count 	= 1
		order.user_id 	= @user.id

		if order.pay_method == "score"
				if @user.score.to_i < params[:score].to_i
					render json: {code: -1, text: "对不起，您的优豆数量不足！"}
					return
				end
				order.status = "待发货"
				order.score  = params[:score]
				order.a_product.remain -= 1
				order.a_product.save
		end

		if order.save
			if order.pay_method == "score"
				ScoreEvent.set_score(@user.id, "fulishe", "兑换福利社商品", 0-params[:score].to_i)
			end
			render json: {code: 0, text: "请付款", price: order.a_product.price, order_id: order.id}
		else
			render json: {code: -1, text: "购买出现异常"}
		end
	end

	def make_payment
		payment = Payment.find_by_order_no(params[:order_no])
		payment = Payment.new if !payment
		payment.order_no    = params[:order_no]
		payment.amount		= params[:amount]
		payment.channel 	= params[:channel]
		payment.currency 	= params[:currency] || "cny"
		payment.client_ip	= request.env['REMOTE_ADDR']

		payment.save

		order = Admin::AOrder.find(params[:order_no])

		res = Pingpp::Charge.create(
	        :order_no => payment.order_no,
	        :amount   => payment.amount,
	        :subject  => order.a_product.name,
	        :body     => "付款购买" + order.a_product.name,
	        :channel  => payment.channel,
	        :currency => payment.currency,
	        :client_ip=> payment.client_ip,
	        :app => {:id => "app_Xjv1GCjDqjDKyX5S"}
	    )

	    render :text=>res
	end

	#ping++的回调网址
	def notify
		payment = Payment.find_by_order_no(params[:data][:object][:order_no])
		if params[:type] == "charge.succeeded"
			payment.status = "paid" 
			payment.paid_at = params[:created]
			payment.save

			order = Admin::AOrder.find(params[:data][:object][:order_no])
			order.status = "待发货"
			order.save

			order.a_product.remain -= 1
			order.a_product.save
		end
		render :text=>"ok"
	end

	def is_order_paid
		order = Admin::AOrder.find(params[:id])
		if order.status == "待发货"
			render text: "yes"
		else
			render text: "no"
		end
	end

	def my_orders
		if !@user
			render json: [] and return;
		end
		orders = Admin::AOrder.page(params[:page]||1).per(params[:count]||20).where(["user_id = ? and hide = 0", @user.id]).order("id desc")
		render json: orders.to_json(:include=>[:a_product=>{:include=>[:a_product_logos]}])
	end

	def receive_order
		order = Admin::AOrder.find_by_id(params[:id])
		if !order
			render :json=>{"desc"=>"找不到此订单", "code"=>-1}
		else
			if order.user_id != @user.id
				render :json=>{"desc"=>"您没有此订单的权限", "code"=>-1}
			end
			order.status = "已收货"
			order.save
			render :json=>{"desc"=>"感谢您的回馈", "code"=>0}
		end
	end

	def make_comment
		order = Admin::AOrder.find(params[:id])
		
		comment = Admin::AComment.new
		comment.a_order_id = order.id
		comment.a_product_id = order.product_id
		comment.user_id = @user.id
		comment.text = params["comment_txt"]
		comment.star = params["comment_star"]
		comment.save

		0.upto(4) do |i|
			next if params["comment_logo_#{i}"].class == String
			
			logo = Admin::ACommentLogo.new
			logo.a_product_id = comment.a_product_id
			logo.a_comment_id = comment.id
			logo.user_id = @user.id
			logo.logo = params["comment_logo_#{i}"]
			logo.save
		end
		order.status = "已评价"
		order.save
		#Mms::Score.trigger_event(:zhiyou_comment, "评价商品", 10*order.details.size, 1, {:user => order.user})
		
		render :json=>{:code=>0, :text=>"感谢您的评价"}
	end

	def delete_order
		order = Admin::AOrder.find_by_id(params[:id])
		if !order
			render :json=>{"text"=>"找不到此订单", "code"=>-1}
		else
			if order.user_id != @user.id
				render :json=>{"text"=>"没有删除此订单的权限", "code"=>-1}
			end
			order.hide = true
			order.save
			render :json=>{"text"=>"删除订单成功", "code"=>0}
		end
	end
end
