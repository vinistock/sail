# frozen_string_literal: true

namespace :sail do
  desc "Loads default setting configurations from sail.yml"
  task load_defaults: :environment do
    Sail::Setting.load_defaults(true)
  end

  desc "Loads partial setting configurations from sail.yml"
  task load_partial_settings: :environment do
    Sail::Setting.load_defaults(false)
  end

  desc "Creates sail.yml using the current state of the database"
  task create_config_file: :environment do
    Sail::Setting.database_to_file
  end
end
