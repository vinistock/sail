# frozen_string_literal: true

module Sail
  module ConstantCollection
    TRUE = "true"
    FALSE = "false"
    STRING_BOOLEANS = %w[true false].freeze
    BOOLEAN = "boolean"
    ON = "on"
    BOOLEANS = [true, false].freeze
    CONFIG_FILE_PATH = "./config/sail.yml"
    STALE = "stale"
  end
end
