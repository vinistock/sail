# frozen_string_literal: true

module Sail
  # Profile
  #
  # The profile model contains the
  # definitions for keeping a collection
  # of settings' values saved. It allows
  # switching between different collections.
  class Profile < ApplicationRecord
    has_many :entries
    has_many :settings, through: :entries
    validates_presence_of :name
  end
end
