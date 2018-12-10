# frozen_string_literal: true

module Sail
  module ApplicationHelper # :nodoc:
    def main_app
      Rails.application.class.routes.url_helpers
    end
  end
end
