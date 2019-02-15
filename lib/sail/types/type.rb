# frozen_string_literal: true

module Sail
  module Types
    # Type
    #
    # This is the base class all types
    # inherit from. It is an abstract class
    # not supposed to be instantiated.
    class Type
      def initialize(setting)
        @setting = setting
      end

      def to_value
        @setting.value.to_s
      end

      def from(value)
        value
      end
    end
  end
end
