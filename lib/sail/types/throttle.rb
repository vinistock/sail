# frozen_string_literal: true

module Sail
  module Types
    # Throttle
    #
    # The Throttle type returns true +X+%
    # of the time (randomly), where +X+ is
    # the value saved in the database.
    #
    # Example:
    #
    # If the setting value is 30, it will
    # return +true+ 30% of the time.
    class Throttle < Type
      def to_value
        100 * rand <= @setting.value.to_f
      end
    end
  end
end
