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

    def self.create_self(name)
      profile = create!(name: name)

      Sail::Setting.select(:id, :value).each do |setting|
        Sail::Entry.create!(
          setting: setting,
          value: setting.value,
          profile: profile
        )
      end

      profile
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
