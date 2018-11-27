# frozen_string_literal: true

module Sail
  class SettingsController < ApplicationController
    def index
      @settings = Setting.by_name(s_params[:query])
      @number_of_pages = (@settings.count.to_f / Sail::Setting::SETTINGS_PER_PAGE).ceil
      @settings = @settings.paginated(s_params[:page])
      fresh_when(@settings)
    end

    def update
      respond_to do |format|
        @setting, @successful_update = Setting.set(s_params[:name], s_params[:value])
        format.js {}
        format.json { @successful_update ? head(:ok) : head(:conflict) }
      end
    end

    def show
      respond_to do |format|
        format.json do
          setting = Sail::Setting.get(s_params[:name])
          render json: { value: setting }
        end
      end
    end

    private

    def s_params
      params.permit(:page, :query, :name, :value)
    end
  end
end
