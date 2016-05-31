# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rufus/scheduler'
require 'rails'
require 'rubygems'
require 'date'

#验证时间差的函数
def days_between(date1, date2)
  d1 = Date.parse(date1)
  d2 = Date.parse(date2)
  (d2 - d1).to_i
end

scheduler = Rufus::Scheduler.new

#从数据库读取每天的更新时间
#@timer = []
#@schedule_time = ScheduleTime.find_by_id(1).timer.strftime('%H:%M')
#@timer = @schedule_time.split(":")
time = 00
timer = 02
puts "开始监控"

Rails.logger.info ("= = = = #{time}#{timer} * * *")
scheduler.cron "#{time} #{timer} * * *" do
  Rails.logger.info ("#{Time.now}")
  #  FetchRecord.set_fetch_time date: Date.today, time: Time.now
  users = User.all
  users.each do |user|
    puts "开始运行"
    begin

      if user.amount.to_i >= 500 && days_between(user.amount_date.strftime("%Y%m%d"),Time.now.strftime("%Y%m%d")).to_i > 30
        puts "产生利息"
        user.month_amount += 20
        user.amount_date = Time.now
        user.save
      else
        puts "不产生利息"
      end
    rescue Exception => e
      Rails.logger.error e.backtrace.join("\n")
    end
  end
  Rails.logger.info ("#{Time.now}")
  puts "结束运行"
end

scheduler.join
