# frozen_string_literal: true

module Sail
  # Types
  #
  # This module holds all setting types
  # classes
  module Types
    autoload :Type, "sail/types/type"
    autoload :Boolean, "sail/types/boolean"
    autoload :Integer, "sail/types/integer"
    autoload :AbTest, "sail/types/ab_test"
    autoload :Array, "sail/types/array"
    autoload :Cron, "sail/types/cron"
    autoload :Date, "sail/types/date"
    autoload :Float, "sail/types/float"
    autoload :ObjModel, "sail/types/obj_model"
    autoload :Range, "sail/types/range"
    autoload :String, "sail/types/string"
    autoload :Throttle, "sail/types/throttle"
    autoload :Uri, "sail/types/uri"
  end
end
