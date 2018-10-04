# frozen_string_literal: true

module Sail
  class SettingsController < ApplicationController
    def index
      @settings = Setting.by_name(params[:query]).paginated(index_params[:page])
      fresh_when(@settings)
    end

    def update
      respond_to do |format|
        @setting = Setting.set(params[:name], params[:value])
        format.js {}
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
