class Admin::Video < ActiveRecord::Base
  mount_uploader :logo, LogoUploader
end
