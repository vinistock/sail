# frozen_string_literal: true

module Sail
  module Types
    # ObjModel
    #
    # The ObjModel type returns the constant
    # for a given string saved.
    # For example:
    #
    # If the saved value is +"Post"+,
    # it will return +Post+ (actual class).
    class ObjModel < Type
      def to_value
        @setting.value.constantize
      end
    end
  end
end
