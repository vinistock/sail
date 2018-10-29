# frozen_string_literal: true

module Sail
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
