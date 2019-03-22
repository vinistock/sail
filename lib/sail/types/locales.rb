# frozen_string_literal: true

module Sail
  module Types
    # Locales
    #
    # Locales settings will keep an array of locales.
    # If the current I18n.locale is included in the array,
    # the setting will return true.
    class Locales < Array
      def to_value
        @setting.value
                .split(Sail.configuration.array_separator)
                .include?(I18n.locale.to_s)
      end
    end
  end
end
