require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CdpWebManyoTask
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework :rspec,
        model_specs: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
    end

    # Time zone for app
    config.time_zone = 'Tokyo'
    # Time zone for database read/write
    config.active_record.default_timezone = :local

    # Set default language to ja
    config.i18n.default_locale = :ja
    # Load I18n translation config file for models
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
  end
end
