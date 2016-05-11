RAILS_ROOT = File.expand_path(File.dirname(__FILE__))

God.watch do |w|
  w.name = 'fetcher'
  w.dir = RAILS_ROOT
  w.start = "ruby #{RAILS_ROOT}/script/schedule_fetch.rb"
  w.log = "#{RAILS_ROOT}/fetcher.log"
  w.keepalive
end
