# frozen_string_literal: true

module Sail
  # Load custom rake tasks in main
  # application
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/sail_tasks.rake"
    end
  end
end
