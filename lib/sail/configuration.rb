# frozen_string_literal: true

module Sail
  class Configuration
    attr_accessor :cache_life_span, :array_separator, :dashboard_auth_lambda

    def initialize
      @cache_life_span = 10.minutes
      @array_separator = ';'
      @dashboard_auth_lambda = nil
    end
  end
end
