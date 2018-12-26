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

    def get(name)
      Sail::Setting.get(name)
    end

    def set(name, value)
      Sail::Setting.set(name, value)
    end

    def reset(name)
      Sail::Setting.reset(name)
    end

    def switcher(positive:, negative:, throttled_by:)
      Sail::Setting.switcher(positive: positive, negative: negative, throttled_by: throttled_by)
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
