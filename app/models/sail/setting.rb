# frozen_string_literal: true

module Sail
  class Setting < ApplicationRecord
    FULL_RANGE = 0...100
    SETTINGS_PER_PAGE = 8
    validates_presence_of :name, :value, :cast_type
    validates_uniqueness_of :name
    enum cast_type: %i[integer string boolean range array float].freeze

    validate :value_is_within_range, if: -> { self.range? }
    validate :value_is_true_or_false, if: -> { self.boolean? }

    scope :paginated, ->(page) do
      select(:name, :description, :value, :cast_type)
        .offset(page.to_i * SETTINGS_PER_PAGE)
        .limit(SETTINGS_PER_PAGE)
    end

    def self.get(name)
      Rails.cache.fetch("setting_get_#{name}", expires_in: Sail.configuration.cache_life_span) do
        cast_setting_value(
          Setting.select(:value, :cast_type).where(name: name).first
        )
      end
    end

    def self.set(name, value)
      setting = Setting.find_by(name: name)
      value_cast = cast_value_for_set(setting, value)
      setting.update_attributes(value: value_cast)
      Rails.cache.delete("setting_get_#{name}")
      setting
    end

    def self.cast_setting_value(setting)
      case setting.cast_type.to_sym
      when :integer, :range
        setting.value.to_i
      when :float
        setting.value.to_f
      when :boolean
        setting.value == Sail::ConstantCollection::TRUE
      when :array
        setting.value.split(Sail.configuration.array_separator)
      else
        setting.value
      end
    end

    def self.cast_value_for_set(setting, value)
      case setting.cast_type.to_sym
      when :integer, :range
        value.to_i
      when :float
        value.to_f
      when :boolean
        if value.is_a?(String)
          value
        else
          value ? 'true' : 'false'
        end
      when :array
        value.is_a?(String) ? value : value.join(Sail.configuration.array_separator)
      else
        value
      end
    end

    def display_name
      self.name.gsub(/[^a-zA-Z\d]/, ' ').titleize
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
