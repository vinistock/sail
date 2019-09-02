# frozen_string_literal: true

module Sail
  # Profile
  #
  # The profile model contains the
  # definitions for keeping a collection
  # of settings' values saved. It allows
  # switching between different collections.
  class Profile < ApplicationRecord
    has_many :entries, dependent: :destroy
    has_many :settings, through: :entries
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validate :only_one_active_profile

    # create_or_update_self
    #
    # Creates or updates a profile with name
    # +name+ saving the values of all settings
    # in the database.
    def self.create_or_update_self(name)
      profile = where(name: name).first_or_initialize
      new_record = profile.new_record?

      Sail::Setting.select(:id, :value).each do |setting|
        entry = setting.entries.where(profile: profile).first_or_initialize(profile: profile, setting: setting)
        entry.value = setting.value
        entry.save!
      end

      profile.save!
      handle_profile_activation(name)
      [profile, new_record]
    end

    # switch
    #
    # Switch to a different setting profile. Set the value
    # of every setting to what was previously saved.
    def self.switch(name)
      Sail::Entry.by_profile_name(name).each do |entry|
        Sail::Setting.set(entry.name, entry.value)
      end

      handle_profile_activation(name)
    end

    # handle_profile_activation
    #
    # Set other profiles to active false and
    # set the selected profile to active true.
    # rubocop:disable Rails/SkipsModelValidations
    def self.handle_profile_activation(name)
      select(:id, :name).where(active: true).update_all(active: false)
      select(:id, :name).where(name: name).update_all(active: true)
    end
    # rubocop:enable Rails/SkipsModelValidations

    # current
    #
    # Returns the currently activated profile
    def self.current
      find_by(active: true)
    end

    private_class_method :handle_profile_activation

    # dirty?
    #
    # A profile is considered dirty if it is active
    # but setting values have been changed and do
    # not match the entries definitions.
    def dirty?
      @dirty ||= entries.any?(&:dirty?)
    end

    private

    def only_one_active_profile
      if active? && Profile.where(active: true).where.not(id: id).count.positive?
        errors.add(:single_active_profile, "Cannot have two active profiles at once")
      end
    end
  end
end
