require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WonderfulEditor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.template_engine false #  HTML を作成しない
      g.javascripts false # javascripts ファイルを作成しない
      g.stylesheets false # スタイルシート(CSS)を作成しない
      g.helper false # helper を作成しない
      g.test_framework :rspec, # テストファイルを作成する
                       view_specs: false, # view の spec を作成しない
                       routing_specs: false, # routing の spec を作成しない
                       helper_specs: false, # helper の spec を作成しない
                       controller_specs: false, # contoller の spec を作成しない
                       fixtures: true, # factory_bot のファイルを作成する
                       request_specs: true # request の spec を作成する
    end
    config.api_only = true
    config.middleware.use ActionDispatch::Flash # CSRF 対策を OFF にする
  end
end
