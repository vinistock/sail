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
    config.middleware.use ActionDispatch::ContentSecurityPolicy::Middleware if defined?(ActionDispatch::ContentSecurityPolicy)
    config.middleware.use Rack::MethodOverride
    config.middleware.use Rails::Rack::Logger
    config.middleware.use Rack::Head
    config.middleware.use Rack::ConditionalGet
    config.middleware.use Rack::ETag

    initializer "sail.assets.precompile" do |app|
      app.config.assets.precompile += %w[sail/undo.svg sail/sliders-h.svg sail/angle-left.svg
                                         sail/angle-right.svg sail/external-link-alt.svg sail/cog.svg sail/check.svg
                                         sail/times.svg sail/application.css sail/application.js]
    end

    initializer "sail" do
      unless Sail.configuration.dashboard_auth_lambda.nil?
        ActiveSupport::Reloader.to_prepare do
          Sail::SettingsController.before_action(Sail.configuration.dashboard_auth_lambda)
        end
      end
    end

    config.after_initialize do
      errors = [ActiveRecord::NoDatabaseError]
      errors << PG::ConnectionBad if defined?(PG)

      config.middleware.use Rails.application.config.session_store || ActionDispatch::Session::CookieStore

      begin
        Sail::Setting.load_defaults unless Rails.env.test?
      rescue *errors
        warn "Skipping setting creation because database doesn't exist"
      end
    end
  end
end
