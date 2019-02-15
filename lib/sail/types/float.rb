# frozen_string_literal: true

module Sail
  module Types
    # Float
    #
    # The Float type manipulates the
    # saved string value into floats.
    class Float < Type
      def to_value
        @setting.value.to_f
      end

      def from(value)
        value.to_f
      end
    end
  end
end
