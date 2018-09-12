# frozen_string_literal: true

module Sail
  class Configuration
    attr_accessor :cache_life_span, :array_separator

    def initialize
      @cache_life_span = 10.minutes
      @array_separator = ';'
    end
  end
end
