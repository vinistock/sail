# frozen_string_literal: true

namespace :sail do
  desc "Loads default setting configurations from sail.yml"
  task load_defaults: :environment do
    Sail::Setting.includes(:entries).load_defaults(true)
  end

  desc "Creates sail.yml using the current state of the database"
  task create_config_file: :environment do
    Sail::Setting.database_to_file
  end
end
