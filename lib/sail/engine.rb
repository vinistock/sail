# frozen_string_literal: true

module Sail
  class Engine < ::Rails::Engine
    require 'jquery-rails'
    isolate_namespace Sail

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'sail' do |app|
      unless Sail.configuration.dashboard_auth_lambda.nil?
        to_prepare do
          Sail::SettingsController.before_action(*Sail.configuration.dashboard_auth_lambda)
        end
      end
    end

    private

    def to_prepare
      klass = defined?(ActiveSupport::Reloader) ? ActiveSupport::Reloader : ActionDispatch::Reloader
      klass.to_prepare(&Proc.new)
    end
  end
end
