# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rufus/scheduler'
require 'rails'
require 'rubygems'
require 'date'

def days_between(date1, date2)
  d1 = Date.parse(date1)
  d2 = Date.parse(date2)
  (d2 - d1).to_i
end
user = User.first
puts User.first.inspect
dates = [["20080801", "20080822"], ["1962-11-11", "1999/12/03"], [ user.amount_date.strftime("%Y%m%d"),Time.now.strftime("%Y%m%d")]]
dates.each do |d1, d2|
  printf "%d day(s) between %s and %s\n", days_between(d1, d2), d1, d2
end

scheduler = Rufus::Scheduler.new

#@timer = []
#@schedule_time = ScheduleTime.find_by_id(1).timer.strftime('%H:%M')
#@timer = @schedule_time.split(":")
time = 38
timer = 17
puts "开始监控"

Rails.logger.info ("= = = = #{time}#{timer} * * *")
puts "尚未开始运行条件"

scheduler.cron "#{time} #{timer} * * *" do
  Rails.logger.info ("#{Time.now}")
#  FetchRecord.set_fetch_time date: Date.today, time: Time.now
  puts "开始运行条件"
  users = User.all
  users.each do |user|
    puts "开始运行"
    begin
      puts user.id
      puts "天数#{days_between(Time.now, user.amount_date)}"
      puts "用户余额:#{user.amount}"
      puts days_between(Time.now, user.amount_date) > 1

      if user.amount == 500 &&  days_between(Time.now, user.amount_date) > 1
        puts "产生利息"
        user.month_amount = 20
        user.amount_date = Time.now
        user.save
      else
        puts "不产生利息"
      end
    rescue Exception => e
      Rails.logger.error e.backtrace.join("\n")
    end
  end
 # @fetch_rules = FetchRule.all
 # @fetch_rules.each do |fetch_rule|
 #   begin
 #     Fetcher.new.start fetch_rule
 #   rescue Exception => e
 #     Rails.logger.error e.backtrace.join("\n")
 #   end
 # end
  Rails.logger.info ("#{Time.now}")
  puts "结束运行条件"
end

scheduler.join
