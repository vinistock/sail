# frozen_string_literal: true

module Sail
  module ApplicationHelper # :nodoc:
    def main_app
      Rails.application.class.routes.url_helpers
    end

    def formatted_date(setting)
      DateTime.parse(setting.value).utc.strftime(Sail::ConstantCollection::INPUT_DATE_FORMAT)
    end
  end
end
