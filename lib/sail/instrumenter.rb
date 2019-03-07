# frozen_string_literal: true

module Sail
  # Instrumenter
  #
  # Class containing methods to instrument
  # setting usage and provide insights to
  # dashboard users.
  class Instrumenter
    USAGES_UNTIL_CACHE_EXPIRE = 500

    # initialize
    #
    # Declare basic hash containing setting
    # statistics
    def initialize
      @statistics = Hash.new(0).with_indifferent_access
    end

    # increment_usage
    #
    # Simply increments the number of
    # times a setting has been called
    def increment_usage_of(setting_name)
      @statistics[setting_name] += 1
      expire_cache_fragment(setting_name) if (@statistics[setting_name] % USAGES_UNTIL_CACHE_EXPIRE).zero?
    end

    # relative_usage_of
    #
    # Calculates the relative usage of
    # a setting compared to all others
    # in percentage
    def relative_usage_of(setting_name)
      return 0.0 if @statistics.empty?

      (100.0 * @statistics[setting_name]) / @statistics.values.reduce(:+)
    end

    private

    def expire_cache_fragment(setting_name)
      ActionController::Base.new.expire_fragment(/name: "#{setting_name}"/)
    end
  end
end
