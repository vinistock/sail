# frozen_string_literal: true

module Sail
  class ApplicationController < ActionController::Base # :nodoc:
    protect_from_forgery with: :exception

    protected

    def current_user
      main_app.scope.request.env["warden"]&.user
    end
  end
end
