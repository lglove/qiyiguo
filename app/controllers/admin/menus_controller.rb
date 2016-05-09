# -*- encoding : utf-8 -*-
class Admin::MenusController < Admin::ApplicationController
  layout "admin"
  before_action :set_admin_menu, only: [:show, :edit, :update, :destroy]

  def index
    #@admin_menus = Admin::Menu.order("position asc, id")
    @admin_menus = Admin::Menu.all
  end

  def show
  end

  def new
    @admin_menu = Admin::Menu.new
  end

  def edit
  end

  def create
    @admin_menu = Admin::Menu.new(admin_menu_params)

    respond_to do |format|
      if @admin_menu.save
        format.html { redirect_to admin_menus_url, notice: '创建成功' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @admin_menu.update(admin_menu_params)
        format.html { redirect_to admin_menus_url, notice: '修改成功' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @admin_menu.destroy
    respond_to do |format|
      format.html { redirect_to admin_menus_url, notice: '成功删除.' }
    end
  end

  private
    def set_admin_menu
      @admin_menu = Admin::Menu.find(params[:id])
    end

    def admin_menu_params
      params.require(:admin_menu).permit(:text, :url, :hide, :position, :parent_id)
    end
end
