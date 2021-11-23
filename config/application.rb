require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Foodshareapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.2
    # 本番環境でapp以下のフォルダを自動で読み込むために
    # config.eager_load_paths += Dir["#{config.root}/app/validators"]
    
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    
    #rails gの際に不要なファイルがインストールされることを防ぐ
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.test_framework :rspec,
        view_specs: false,
        helper_specs: false,
        controller_specs: false,
        routing_specs: false
    end

    # エラーメッセージを表示する際にfield_with_classの挿入を防ぐ
    config.action_view.field_error_proc = Proc.new{ |html_tag, instance| html_tag}

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
