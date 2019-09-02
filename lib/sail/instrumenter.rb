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
      @statistics = { settings: {} }.with_indifferent_access
    end

    # []
    #
    # Accessor method for the statistics to guarantee
    # proper initialization of hashes.
    def [](name)
      @statistics[:settings][name] = { usages: 0, failures: 0 }.with_indifferent_access if @statistics[:settings][name].blank?
      @statistics[:settings][name]
    end

    # increment_usage
    #
    # Simply increments the number of
    # times a setting has been called
    def increment_usage_of(setting_name)
      self[setting_name][:usages] += 1
      expire_cache_fragment(setting_name) if (self[setting_name][:usages] % USAGES_UNTIL_CACHE_EXPIRE).zero?
    end

    # relative_usage_of
    #
    # Calculates the relative usage of
    # a setting compared to all others
    # in percentage
    def relative_usage_of(setting_name)
      return 0.0 if @statistics[:settings].empty?

      (100.0 * self[setting_name][:usages]) / @statistics[:settings].map { |_, entry| entry[:usages] }.reduce(:+)
    end

    # increment_failure_of
    #
    # Counts the number of failed code block executions
    # enveloped by a given setting. If the number of failures
    # exceeds the amount configured, resets the setting value
    def increment_failure_of(setting_name)
      self[setting_name][:failures] += 1
      Sail.reset(setting_name) if self[setting_name][:failures] > Sail.configuration.failures_until_reset
    end

    private

    def expire_cache_fragment(setting_name)
      ActionController::Base.new.expire_fragment(/name: "#{setting_name}"/)
    end
  end
end
