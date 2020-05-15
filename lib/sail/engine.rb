# frozen_string_literal: true

module Sail
  # Engine
  # Defines initializers and
  # after initialize hooks
  class Engine < ::Rails::Engine
    require "sprockets/railtie"
    isolate_namespace Sail

    config.generators do |g|
      g.test_framework :rspec
    end

    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::ContentSecurityPolicy::Middleware if defined?(ActionDispatch::ContentSecurityPolicy)
    config.middleware.use Rack::MethodOverride
    config.middleware.use Rails::Rack::Logger
    config.middleware.use Rack::Head
    config.middleware.use Rack::ConditionalGet
    config.middleware.use Rack::ETag

    initializer "sail.assets.precompile" do |app|
      app.config.assets.precompile += %w[sail/refresh.svg sail/sort.svg sail/angle-left.svg
                                         sail/angle-right.svg sail/link.svg sail/cog.svg sail/checkmark.svg
                                         sail/error.svg sail/application.css sail/application.js]
    end

    initializer "sail" do
      unless Sail.configuration.dashboard_auth_lambda.nil?
        to_prepare do
          Sail::SettingsController.before_action(*Sail.configuration.dashboard_auth_lambda)
        end
      end
    end

    config.after_initialize do
      errors = [ActiveRecord::NoDatabaseError]
      errors << PG::ConnectionBad if defined?(PG)

      begin
        Sail::Setting.load_defaults unless Rails.env.test?
      rescue *errors
        warn "Skipping setting creation because database doesn't exist"
      end
    end

    private

    def to_prepare
      klass = defined?(ActiveSupport::Reloader) ? ActiveSupport::Reloader : ActionDispatch::Reloader
      klass.to_prepare(&Proc.new)
    end
  end
end
