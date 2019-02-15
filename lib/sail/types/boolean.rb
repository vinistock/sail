# frozen_string_literal: true

module Sail
  module Types
    # Boolean
    #
    # The Boolean type simply returns true
    # or false depending on what is stored
    # in the database.
    class Boolean < Type
      def to_value
        @setting.value == Sail::ConstantCollection::TRUE
      end

      def from(value)
        if value.is_a?(::String)
          check_for_on_or_boolean(value)
        elsif value.nil?
          Sail::ConstantCollection::FALSE
        else
          value.to_s
        end
      end

      private

      def check_for_on_or_boolean(value)
        value == Sail::ConstantCollection::ON ? Sail::ConstantCollection::TRUE : value
      end
    end
  end
end
