# frozen_string_literal: true

module Sail
  class ApplicationController < ActionController::Base # :nodoc:
    protect_from_forgery with: :exception

    protected

    def current_user
      main_app.scope.request.env["warden"]&.user
    end

    def default_url_options
      { locale: I18n.locale }
    end

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end
  end
end
