# frozen_string_literal: true

module Sail
  module Types
    # AbTest
    #
    # The AbTest setting type returns
    # true or false randomly (50% chance).
    class AbTest < Boolean
      def to_value
        if @setting.value == Sail::ConstantCollection::TRUE
          Sail::ConstantCollection::BOOLEANS.sample
        else
          false
        end
      end
    end
  end
end
