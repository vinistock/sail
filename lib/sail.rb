# frozen_string_literal: true

require "sail/engine"
require "sail/constant_collection"
require "sail/configuration"
require "sail/value_cast"
require "true_class"
require "false_class"

module Sail # :nodoc:
  class << self
    attr_writer :configuration

    # Gets the value of a setting casted with the
    # appropriate type.
    #
    # Response is cached until the setting's value
    # is updated or until the time specific in
    # the configuration expires.
    def get(name)
      Sail::Setting.get(name)
    end

    # Sets the value of a setting
    #
    # Updating a setting's value will cause its
    # cache to expire.
    #
    # Passed values are cast to string before
    # saving to the database. For instance,
    # the statement below will appropriately
    # update the setting value to "true".
    #
    # Sail.set(:boolean_setting, true)
    #
    def set(name, value)
      Sail::Setting.set(name, value)
    end

    # Resets the value of a setting
    #
    # Restores the original value defined
    # in config/sail.yml
    def reset(name)
      Sail::Setting.reset(name)
    end

    # Switches between the value of two settings randomly
    #
    # +throttled_by+: a throttle type setting
    # +positive+: a setting to be returned when the throttle returns true
    # +negative+: a setting to be returned when the throttle returns false
    #
    # Based on the +throttled_by+ setting, this method will
    # return either the value of +positive+ or +negative+.
    #
    # If +throttled_by+ returns true, the casted value of +positive+
    # is returned. When false, the casted value of +negative+ is returned.
    def switcher(positive:, negative:, throttled_by:)
      Sail::Setting.switcher(positive: positive, negative: negative, throttled_by: throttled_by)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
