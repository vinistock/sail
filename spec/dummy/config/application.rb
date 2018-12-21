require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'sail'

module Dummy
  class Application < Rails::Application
    if Rails::VERSION::MAJOR >= 5
      config.load_defaults 5.1
      config.active_record.sqlite3.represent_boolean_as_integer = true
    end

    Sail.configure do |config|
      config.enable_search_auto_submit = true
    end
  end
end
