class Designer < ActiveRecord::Base
  has_many :users
  has_many :orders
  mount_uploader :logo, LogoUploader
end
