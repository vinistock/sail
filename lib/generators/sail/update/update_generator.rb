# frozen_string_literal: true

require "rails/generators/migration"

module Sail
  module Generators
    # UpdateGenerator
    #
    # The UpdateGenerator analyzes the current
    # state of the database and helps users
    # upgrade to the latest Sail version.
    class UpdateGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)
      desc "Update an application to Sail's latest version"

      def self.next_migration_number(_path)
        if @prev_migration_nr
          @prev_migration_nr += 1
        else
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        end

        @prev_migration_nr.to_s
      end

      def copy_migrations
        # Add migration to add group to settings
        # if upgrading from Sail <= 1.x.x

        if Sail::Setting.column_names.exclude?("group")
          migration_template "add_group_to_sail_settings.rb",
                             "db/migrate/add_group_to_sail_settings.rb",
                             migration_version: migration_version
        end

        # Add migration to create profiles
        # if upgrading from Sail <= 2.x.x

        unless ActiveRecord::Base.connection.table_exists?("sail_profiles")
          migration_template "#{__dir__}/../install/templates/create_sail_profiles.rb",
                             "db/migrate/create_sail_profiles.rb",
                             migration_version: migration_version
        end
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end
    end
  end
end
