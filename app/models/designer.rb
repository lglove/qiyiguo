class Designer < ActiveRecord::Base
  has_many :users
  mount_uploader :logo, LogoUploader
end
