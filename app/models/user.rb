class User < ActiveRecord::Base
  has_one :userInfo
  has_many :userAddress
  has_many :orders
  def self.md5(text)
    Digest::MD5.hexdigest(text)
  end
end
