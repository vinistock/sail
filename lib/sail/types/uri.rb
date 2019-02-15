# frozen_string_literal: true

module Sail
  module Types
    # Uri
    #
    # The Uri type returns an URI
    # object based on the string
    # saved in the database.
    class Uri < Type
      def to_value
        URI(@setting.value)
      end
    end
  end
end
