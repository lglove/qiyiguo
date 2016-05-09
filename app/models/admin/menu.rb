class Admin::Menu < ActiveRecord::Base
  acts_as_tree :order=>"position", :conditions=>"hide = 0"
end
