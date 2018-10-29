# frozen_string_literal: true

require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class SailGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_sail_migration
        migration_template 'settings_migration.rb',
                           "db/migrate/#{target_name}.rb",
                           migration_version: migration_version, migration_name: migration_name
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if Rails.version.start_with?('5')
      end

      def target_name
        name || 'create_sail_settings'
      end

      def migration_name
        target_name.camelize
      end
    end
  end
end
