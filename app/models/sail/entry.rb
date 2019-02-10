# frozen_string_literal: true

module Sail
  # Entry
  #
  # The Entry class holds the saved value
  # for settings for each profile. It is
  # a model for representing the N x N
  # relationship between profiles and settings
  class Entry < ApplicationRecord
    belongs_to :setting
    belongs_to :profile
    validates_presence_of :value, :setting, :profile

    scope :by_profile_name, ->(name) { joins(:profile).where("sail_profiles.name = ?", name) }

    def name
      setting.name
    end
  end
end
