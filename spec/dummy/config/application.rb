# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'sail'

module Dummy
  class Application < Rails::Application
    if Rails::VERSION::MAJOR < 6
      config.active_record.sqlite3.represent_boolean_as_integer = true
      config.load_defaults 5.0
    else
      config.load_defaults 6.1
    end

    Sail.configure do |config|
      config.enable_search_auto_submit = true
    end

    I18n.available_locales = %i[en es fr]
  end
end
