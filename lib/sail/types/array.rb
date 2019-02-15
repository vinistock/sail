# frozen_string_literal: true

module Sail
  module Types
    # Array
    #
    # This type allows defining an
    # array using a string and a separator
    # (defined in the configuration).
    class Array < Type
      def to_value
        @setting.value.split(Sail.configuration.array_separator)
      end

      def from(value)
        value.is_a?(::String) ? value : value.join(Sail.configuration.array_separator)
      end
    end
  end
end
