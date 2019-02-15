# frozen_string_literal: true

module Sail
  module Types
    # Integer
    #
    # The Integer type manipulates the
    # saved string value into integers.
    class Integer < Type
      def to_value
        @setting.value.to_i
      end

      def from(value)
        value.to_i
      end
    end
  end
end
