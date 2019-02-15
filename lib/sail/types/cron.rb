# frozen_string_literal: true

module Sail
  module Types
    # Cron
    #
    # The Cron type returns true
    # if the saved cron string
    # matches the current time
    # (ignores seconds).
    class Cron < Type
      def to_value
        Fugit::Cron.new(@setting.value).match?(DateTime.now.utc.change(sec: 0))
      end
    end
  end
end
