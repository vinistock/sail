# frozen_string_literal: true

module Sail
  # Configuration
  # This class keeps the configuration
  # data for the gem.
  # Defaults be found here and can be
  # overridden in an initializer, environment
  # file or application.rb
  class Configuration
    attr_accessor :cache_life_span, :array_separator, :dashboard_auth_lambda,
                  :back_link_path, :enable_search_auto_submit, :days_until_stale,
                  :enable_logging

    def initialize
      @cache_life_span = 6.hours
      @array_separator = ";"
      @dashboard_auth_lambda = nil
      @back_link_path = "root_path"
      @enable_search_auto_submit = true
      @days_until_stale = 60
      @enable_logging = true
    end
  end
end
