# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :aliyun
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
#coding: utf-8
#require 'carrierwave/processing/mini_magick'
## 在图片空间里面定义好的“缩略图版本名称”，以防止调用错误
#IMAGE_UPLOADER_ALLOW_IMAGE_VERSION_NAMES = %(20x20 30x30 240x240 100x100 120x90 160x120 250x187 320 640 800)
#class ImageUploader < CarrierWave::Uploader::Base
#  def store_dir
#    "#{model.class.to_s.underscore}/#{mounted_as}"
#  end

#  def default_url
#    # 搞一个大一点的默认图片取名 blank.png 用 FTP 传入图片空间，用于作为默认图片
#    # 由于有自动的缩略图处理，小图也不成问题
#    # Setting.upload_url 这个是你的图片空间 URL
#    "#{Setting.upload_url}/blank.png#{version_name}"
#  end

#  # 覆盖 url 方法以适应“图片空间”的缩略图命名
#  def url(version_name = "")
#    @url ||= super({})
#    version_name = version_name.to_s
#    return @url if version_name.blank?
#    if not version_name.in?(IMAGE_UPLOADER_ALLOW_IMAGE_VERSION_NAMES)
#      # 故意在调用了一个没有定义的“缩略图版本名称”的时候抛出异常，以便开发的时候能及时看到调错了
#      raise "ImageUploader version_name:#{version_name} not allow."
#    end
#    [@url,version_name].join("!") # 我这里在图片空间里面选用 ! 作为“间隔标志符”
#  end

#  def extension_white_list
#    %w(jpg jpeg gif png)
#  end

#  def filename
#    if super.present?
#      model.uploader_secure_token ||= SecureRandom.uuid.gsub("-","")
#      Rails.logger.debug("(BaseUploader.filename) #{model.uploader_secure_token}")
#      "#{model.uploader_secure_token}.#{file.extension.downcase}"
#    end
#  end
#end

#class User < ActiveRecord::Base
#  mount_uploader :avatar, ImageUploader
#end

#class Photo < ActiveRecord::Base
#  mount_uploader :image, ImageUploader
#end

#class Category < ActiveRecord::Base
#  mount_uploader :cover, ImageUploader
#end

## ... 所有需要图片上传 Uploader 的地方都用 ImageUploader
