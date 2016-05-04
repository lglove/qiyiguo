class User < ActiveRecord::Base
  has_one :userInfo
  has_many :userAddress
  def self.md5(text)
    Digest::MD5.hexdigest(text)
  end
end
