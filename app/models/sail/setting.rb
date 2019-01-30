# frozen_string_literal: true

require "fugit"

module Sail
  # Setting
  # This is the model used for settings
  # it contains all data definitions,
  # validations, scopes and methods
  class Setting < ApplicationRecord
    class UnexpectedCastType < StandardError; end

    extend Sail::ValueCast
    FULL_RANGE = (0...100).freeze
    SETTINGS_PER_PAGE = 8
    AVAILABLE_MODELS = Dir["#{Rails.root}/app/models/*.rb"]
                       .map { |dir| dir.split("/").last.camelize.gsub(".rb", "") }.freeze

    validates_presence_of :name, :value, :cast_type
    validates_uniqueness_of :name
    enum cast_type: %i[integer string boolean range array float
                       ab_test cron obj_model date uri throttle].freeze

    validate :value_is_within_range, if: -> { range? }
    validate :value_is_true_or_false, if: -> { boolean? || ab_test? }
    validate :cron_is_valid, if: -> { cron? }
    validate :model_exists, if: -> { obj_model? }
    validate :date_is_valid, if: -> { date? }
    validate :uri_is_valid, if: -> { uri? }

    scope :paginated, lambda { |page|
      select(:name, :description, :group, :value, :cast_type, :updated_at)
        .offset(page.to_i * SETTINGS_PER_PAGE)
        .limit(SETTINGS_PER_PAGE)
    }

    scope :by_query, lambda { |query|
      if cast_types.key?(query) || query == Sail::ConstantCollection::STALE
        send(query)
      elsif select(:id).by_group(query).exists?
        by_group(query)
      elsif query.to_s.include?(Sail::ConstantCollection::RECENT)
        recently_updated(query.delete("recent ").strip)
      else
        by_name(query)
      end
    }

    scope :by_group, ->(group) { where(group: group) }
    scope :by_name, ->(name) { name.present? ? where("name LIKE ?", "%#{name}%") : all }
    scope :stale, -> { where("updated_at < ?", Sail.configuration.days_until_stale.days.ago) }
    scope :recently_updated, ->(amount) { where("updated_at >= ?", amount.to_i.hours.ago) }
    scope :ordered_by, ->(field) { column_names.include?(field) ? order("#{field}": :desc) : all }

    def self.get(name)
      Sail.instrumenter.increment_usage_of(name)

      Rails.cache.fetch("setting_get_#{name}", expires_in: Sail.configuration.cache_life_span) do
        cast_setting_value(
          Setting.select(:value, :cast_type).where(name: name).first
        )
      end
    end

    def self.set(name, value)
      setting = Setting.find_by(name: name)
      value_cast = cast_value_for_set(setting, value)
      success = setting.update_attributes(value: value_cast)
      Rails.cache.delete("setting_get_#{name}") if success
      [setting, success]
    end

    def self.cast_setting_value(setting)
      return if setting.nil?

      send("#{setting.cast_type}_get", setting.value)
    end

    def self.cast_value_for_set(setting, value)
      send("#{setting.cast_type}_set", value)
    end

    def self.switcher(positive:, negative:, throttled_by:)
      setting = select(:cast_type).where(name: throttled_by).first
      raise ActiveRecord::RecordNotFound, "Can't find throttle setting" if setting.nil?

      raise UnexpectedCastType unless setting.throttle?

      get(throttled_by) ? get(positive) : get(negative)
    end

    def self.reset(name)
      if File.exist?(config_file_path)
        defaults = YAML.load_file(config_file_path)
        set(name, defaults[name]["value"])
      end
    end

    def self.load_defaults(override = false)
      if File.exist?(config_file_path) &&
         ActiveRecord::Base.connection.table_exists?(table_name)

        destroy_all if override
        config = YAML.load_file(config_file_path)
        find_or_create_settings(config)
        destroy_missing_settings(config.keys)
      end
    end

    def self.config_file_path
      Sail::ConstantCollection::CONFIG_FILE_PATH
    end

    def self.destroy_missing_settings(keys)
      deleted_settings = pluck(:name) - keys
      where(name: deleted_settings).destroy_all
    end

    def self.find_or_create_settings(config)
      config.each do |name, attrs|
        string_attrs = attrs.merge(name: name)
        string_attrs.update(string_attrs) { |_, v| v.to_s }
        where(name: name).first_or_create(string_attrs)
      end
    end

    private_class_method :config_file_path, :destroy_missing_settings,
                         :find_or_create_settings

    def display_name
      name.gsub(/[^a-zA-Z\d]/, " ").titleize
    end

    def stale?
      return unless Sail.configuration.days_until_stale.present?

      updated_at < Sail.configuration.days_until_stale.days.ago
    end

    def relevancy
      Sail.instrumenter.relative_usage_of(name) / Sail::Setting.count
    end

    private

    def model_exists
      errors.add(:invalid_model, "Model does not exist") unless AVAILABLE_MODELS.include?(value)
    end

    def value_is_true_or_false
      if Sail::ConstantCollection::STRING_BOOLEANS.exclude?(value)
        errors.add(:not_a_boolean_error,
                   "Boolean settings only take values inside #{Sail::ConstantCollection::STRING_BOOLEANS}")
      end
    end

    def value_is_within_range
      unless FULL_RANGE.cover?(self.class.cast_setting_value(self))
        errors.add(:outside_range_error,
                   "Range settings only take values inside range #{FULL_RANGE}")
      end
    end

    def date_is_valid
      DateTime.parse(value)
    rescue ArgumentError
      errors.add(:invalid_date, "Date format is invalid")
    end

    def cron_is_valid
      if Fugit::Cron.new(value).nil?
        errors.add(:invalid_cron_string,
                   "Setting value is not a valid cron")
      end
    end

    def uri_is_valid
      URI(value)
    rescue URI::InvalidURIError
      errors.add(:invalid_uri, "URI value is invalid")
    end
  end
end
