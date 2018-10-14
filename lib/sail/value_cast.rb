# frozen_string_literal: true

module Sail
  module ValueCast
    # Section for get value casts

    def integer_get(value)
      value.to_i
    end

    def range_get(value)
      value.to_i
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

    def string_get(value)
      value
    end

    # Section for set value casts

    def integer_set(value)
      value.to_i
    end

    def range_set(value)
      value.to_i
    end

    def float_set(value)
      value.to_f
    end

    def boolean_set(value)
      if value.is_a?(String)
        value == Sail::ConstantCollection::ON ? Sail::ConstantCollection::TRUE : value
      else
        value ? Sail::ConstantCollection::TRUE : Sail::ConstantCollection::FALSE
      end
    end

    def ab_test_set(value)
      if value.is_a?(String)
        value == Sail::ConstantCollection::ON ? Sail::ConstantCollection::TRUE : value
      else
        value ? Sail::ConstantCollection::TRUE : Sail::ConstantCollection::FALSE
      end
    end

    def array_set(value)
      value.is_a?(String) ? value : value.join(Sail.configuration.array_separator)
    end

    def string_set(value)
      value
    end
  end
end
