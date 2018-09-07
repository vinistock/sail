module Sail
  class SettingsController < ApplicationController
    def index
      @settings = Setting.paginated(index_params[:page])
      fresh_when(@settings)
    end

    def update
      respond_to do |format|
        @setting = Setting.set(params[:name], value)
        format.js {}
      end
    end

    private

    def value
      if params[:cast_type] == 'boolean'
        params[:value] == 'on'
      else
        params[:value]
      end
    end

    def index_params
      params.permit(:page)
    end
  end
end
