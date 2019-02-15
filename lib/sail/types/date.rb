# frozen_string_literal: true

module Sail
  module Types
    # Date
    #
    # The Date type parses the saved
    # string into a DateTime object.
    class Date < Type
      def to_value
        DateTime.parse(@setting.value)
      end
    end
  end
end
