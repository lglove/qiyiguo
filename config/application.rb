require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Aizhong
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.time_zone = 'Beijing'

    config.active_record.default_timezone = :local
    config.active_record.raise_in_transactional_callbacks = true

    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.precompile << /\.(?:svg|eot|woff|ttf|otf)$/
  end
end

class ActiveSupport::TimeWithZone
  def to_s(format = :default)
    if format == :db
      time.strftime("%Y-%m-%d %H:%M:%S")
    elsif formatter = ::Time::DATE_FORMATS[format]
      formatter.respond_to?(:call) ? formatter.call(self).to_s : strftime(formatter)
    else
      "#{time.strftime("%Y-%m-%d %H:%M:%S")} #{formatted_offset(false, 'UTC')}" # mimicking Ruby 1.9 Time#to_s format
    end
  end
end
