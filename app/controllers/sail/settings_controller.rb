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
          render json: {
            value: Sail::Setting.get(s_params[:name])
          }
        end
      end
    end

    def switcher
      respond_to do |format|
        format.json do
          begin
            render json: {
              value: Sail::Setting.switcher(positive: s_params[:positive],
                                            negative: s_params[:negative],
                                            throttled_by: s_params[:throttled_by])
            }
          rescue Sail::Setting::UnexpectedCastType
            head(:bad_request)
          rescue ActiveRecord::RecordNotFound
            head(:not_found)
          end
        end
      end
    end

    private

    def s_params
      params.permit(:page, :query, :name,
                    :value, :positive, :negative, :throttled_by)
    end
  end
end
