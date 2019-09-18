# frozen_string_literal: true

module Sail
  module Types
    # Set
    #
    # This type allows defining a set
    #  using a string and a separator
    # (defined in the configuration).
    class Set < Type
      def to_value
        ::Set[*@setting.value.split(Sail.configuration.array_separator)]
      end

      def from(value)
        value.is_a?(::String) ? value : value.join(Sail.configuration.array_separator)
      end
    end
  end
end
