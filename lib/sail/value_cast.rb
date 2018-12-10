# frozen_string_literal: true

module Sail
  # ValueCast
  # This module was made to be extended
  # by the Setting model.
  # It contains all setting type value
  # casts so that the model itself can
  # use dynamic invocation
  module ValueCast
    # Section for get value casts

    def integer_get(value)
      value.to_i
    end

    def range_get(value)
      value.to_i
    end

    def date_get(value)
      DateTime.parse(value)
    end

    def float_get(value)
      value.to_f
    end

    def boolean_get(value)
      value == Sail::ConstantCollection::TRUE
    end

    def array_get(value)
      value.split(Sail.configuration.array_separator)
    end

    def ab_test_get(value)
      value == Sail::ConstantCollection::TRUE ? Sail::ConstantCollection::BOOLEANS.sample : false
    end

    def cron_get(value)
      Fugit::Cron.new(value).match?(DateTime.now.utc.change(sec: 0))
    end

    def obj_model_get(value)
      value.constantize
    end

    def string_get(value)
      value
    end

    def uri_get(value)
      URI(value)
    end

    def throttle_get(value)
      100 * rand <= value.to_f
    end

    # Section for set value casts

    def integer_set(value)
      value.to_i
    end

    def range_set(value)
      value.to_i
    end

    def date_set(value)
      value
    end

    def float_set(value)
      value.to_f
    end

    def boolean_set(value)
      if value.is_a?(String)
        value == Sail::ConstantCollection::ON ? Sail::ConstantCollection::TRUE : value
      elsif value.nil?
        Sail::ConstantCollection::FALSE
      else
        value.to_s
      end
    end

    def ab_test_set(value)
      if value.is_a?(String)
        value == Sail::ConstantCollection::ON ? Sail::ConstantCollection::TRUE : value
      elsif value.nil?
        Sail::ConstantCollection::FALSE
      else
        value.to_s
      end
    end

    def array_set(value)
      value.is_a?(String) ? value : value.join(Sail.configuration.array_separator)
    end

    def obj_model_set(value)
      value
    end

    def cron_set(value)
      value
    end

    def string_set(value)
      value
    end

    def uri_set(value)
      value
    end

    def throttle_set(value)
      value
    end
  end
end
