# frozen_string_literal: true

module Sail
  class Setting < ApplicationRecord
    FULL_RANGE = 0...100
    validates_presence_of :name, :value, :cast_type
    validates_uniqueness_of :name
    enum cast_type: %i[integer string boolean range array].freeze

    validate :value_is_within_range, if: -> { self.range? }
    validate :value_is_true_or_false, if: -> { self.boolean? }

    def self.get(name)
      Rails.cache.fetch("setting_get_#{name}", expires_in: 10.minutes) do
        cast_setting_value(
          Setting.select(:value, :cast_type).where(name: name).first
        )
      end
    end

    def self.set(name, value)
      Setting.where(name: name).update(value: value)
      Rails.cache.delete("setting_get_#{name}")
    end

    def self.cast_setting_value(setting)
      case setting.cast_type.to_sym
      when :integer, :range
        setting.value.to_i
      when :boolean
        setting.value == Sail::ConstantCollection::TRUE
      when :array
        setting.value.split(';')
      else
        setting.value
      end
    end

    private

    def value_is_true_or_false
      if Sail::ConstantCollection::BOOLEANS.exclude?(value)
        errors.add(:not_a_boolean_error,
                   "Boolean settings only take values inside #{Sail::ConstantCollection::BOOLEANS}")
      end
    end

    def value_is_within_range
      unless FULL_RANGE.cover?(self.class.cast_setting_value(self))
        errors.add(:outside_range_error,
                   "Range settings only take values inside range #{FULL_RANGE}")
      end
    end
  end
end
