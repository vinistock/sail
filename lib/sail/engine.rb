# frozen_string_literal: true

module Sail
  class Engine < ::Rails::Engine
    isolate_namespace Sail

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'sail' do
      unless Sail.configuration.dashboard_auth_lambda.nil?
        to_prepare do
          Sail::SettingsController.before_action(*Sail.configuration.dashboard_auth_lambda)
        end
      end
    end

    config.after_initialize do
      if !Rails.env.test? &&
          File.exist?("#{Rails.root}/config/sail.yml") &&
          ActiveRecord::Base.connection.table_exists?("sail_settings")

        YAML.load_file("#{Rails.root}/config/sail.yml").each do |name, attrs|
          string_attrs = attrs.merge(name: name)
          string_attrs.update(string_attrs) { |_, v| v.to_s }
          Sail::Setting.where(name: name).first_or_create(string_attrs)
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
