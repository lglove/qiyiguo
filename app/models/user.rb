class User < ActiveRecord::Base
  def self.md5(text)
    Digest::MD5.hexdigest(text)
  end
end
