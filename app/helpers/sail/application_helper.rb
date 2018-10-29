# frozen_string_literal: true

module Sail
  module ApplicationHelper
    def number_of_pages
      @number_of_pages ||= (Sail::Setting.count.to_f / Sail::Setting::SETTINGS_PER_PAGE).ceil
    end
  end
end
