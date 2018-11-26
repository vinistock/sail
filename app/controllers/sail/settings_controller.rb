# frozen_string_literal: true

module Sail
  class SettingsController < ApplicationController
    def index
      @settings = Setting.by_name(params[:query])
      @number_of_pages = (@settings.count.to_f / Sail::Setting::SETTINGS_PER_PAGE).ceil
      @settings = @settings.paginated(index_params[:page])
      fresh_when(@settings)
    end

    def update
      respond_to do |format|
        @setting, @successful_update = Setting.set(params[:name], params[:value])
        format.js {}
        format.json { @successful_update ? head(:ok) : head(:conflict) }
      end
    end

    def show
      respond_to do |format|
        format.json do
          setting = Sail::Setting.get(params[:name])
          render json: { value: setting }
        end
      end
    end

    private

    def index_params
      params.permit(:page)
    end
  end
end
