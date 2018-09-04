module Sail
  class SettingsController < ApplicationController
    def index
      @settings = Setting.paginated(index_params[:page])
    end

    private

    def index_params
      params.permit(:page)
    end
  end
end
