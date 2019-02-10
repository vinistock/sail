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
    validates_presence_of :name

    # create_or_update_self
    #
    # Creates or updates a profile with name
    # +name+ saving the values of all settings
    # in the database.
    def self.create_or_update_self(name)
      profile = first_or_initialize(name: name)
      new_record = profile.new_record?

      Sail::Setting.select(:id, :value).each do |setting|
        Sail::Entry.where(
          setting: setting,
          profile: profile
        ).first_or_create!(
          setting: setting,
          value: setting.value,
          profile: profile
        )
      end

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
    end
  end
end
