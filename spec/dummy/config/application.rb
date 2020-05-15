# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'sail'

module Dummy
  class Application < Rails::Application
    config.load_defaults 5.0

    if Rails::VERSION::MAJOR < 6
      config.active_record.sqlite3.represent_boolean_as_integer = true
    end

    Sail.configure do |config|
      config.enable_search_auto_submit = true
    end

    I18n.available_locales = %i[en es fr]
  end
end
