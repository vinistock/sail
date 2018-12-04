# frozen_string_literal: true

module Sail
  module ApplicationHelper
    def main_app
      Rails.application.class.routes.url_helpers
    end
  end
end
