# frozen_string_literal: true

require "fugit"

module Sail
  # Setting
  # This is the model used for settings
  # it contains all data definitions,
  # validations, scopes and methods
  class Setting < ApplicationRecord
    class UnexpectedCastType < StandardError; end

    FULL_RANGE = (0...100).freeze
    AVAILABLE_MODELS = Dir[Rails.root.join("app", "models", "*.rb")]
                       .map { |dir| dir.split("/").last.camelize.gsub(".rb", "") }.freeze

    has_many :entries, dependent: :destroy
    attr_reader :caster

    validates :value, :cast_type, presence: true
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    enum cast_type: %i[integer string boolean range array float
                       ab_test cron obj_model date uri throttle
                       locales set].freeze

    validate :value_is_within_range, if: -> { range? }
    validate :value_is_true_or_false, if: -> { boolean? || ab_test? }
    validate :cron_is_valid, if: -> { cron? }
    validate :model_exists, if: -> { obj_model? }
    validate :date_is_valid, if: -> { date? }
    validate :uri_is_valid, if: -> { uri? }

    after_initialize :instantiate_caster

    scope :paginated, lambda { |page, per_page| offset(page.to_i * per_page).limit(per_page) }

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
    scope :for_value_by_name, ->(name) { select(:value, :cast_type).where(name: name) }

    def self.get(name)
      Sail.instrumenter.increment_usage_of(name)

      cached_setting = Rails.cache.read("setting_get_#{name}")
      return cached_setting unless cached_setting.nil?

      setting = Setting.for_value_by_name(name).first
      return if setting.nil?

      setting_value = setting.safe_cast

      unless setting.should_not_cache?
        Rails.cache.write(
          "setting_get_#{name}", setting_value,
          expires_in: Sail.configuration.cache_life_span
        )
      end

      setting_value
    end

    def self.set(name, value)
      setting = Setting.find_by(name: name)
      value_cast = setting.caster.from(value)
      success = setting.update(value: value_cast)
      Rails.cache.delete("setting_get_#{name}") if success
      [setting, success]
    end

    def self.switcher(positive:, negative:, throttled_by:)
      setting = select(:cast_type).find_by(name: throttled_by)
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

    def self.database_to_file
      attributes = {}

      Setting.all.find_each do |setting|
        setting_attrs = setting.attributes.except("id", "name", "created_at", "updated_at", "cast_type")
        attributes[setting.name] = setting_attrs.merge("cast_type" => setting.cast_type)
      end

      File.open(config_file_path, "w") { |f| f.write(attributes.to_yaml) }
    end

    private_class_method :config_file_path, :destroy_missing_settings,
                         :find_or_create_settings

    def display_name
      name.gsub(/[^a-zA-Z\d]/, " ").titleize
    end

    def stale?
      return if Sail.configuration.days_until_stale.blank?

      updated_at < Sail.configuration.days_until_stale.days.ago
    end

    def relevancy
      (Sail.instrumenter.relative_usage_of(name) / Sail::Setting.count).round(1)
    end

    def should_not_cache?
      ab_test? || cron? || throttle?
    end

    def safe_cast
      try(:caster).try(:to_value)
    end

    private

    def instantiate_caster
      return unless has_attribute?(:cast_type)

      @caster = "Sail::Types::#{cast_type.camelize}"
                .constantize
                .new(self)
    end

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
      unless FULL_RANGE.cover?(caster.to_value)
        errors.add(:outside_range_error,
                   "Range settings only take values inside range #{FULL_RANGE}")
      end
    end

    def date_is_valid
      DateTime.parse(value).utc
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
