# frozen_string_literal: true

namespace :sail do
  desc "Loads default setting configurations from sail.yml"
  task :load_defaults do
    Sail::Setting.load_defaults(true)
  end
end
