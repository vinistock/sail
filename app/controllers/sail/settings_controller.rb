# frozen_string_literal: true

require_dependency "sail/application_controller"

module Sail
  # SettingsController
  # This is the main controller for settings
  # Implements all actions for the dashboard
  # and for the JSON API
  class SettingsController < ApplicationController
    after_action :log_update, only: %i[update reset], if: -> { Sail.configuration.enable_logging && @successful_update }

    # rubocop:disable AbcSize
    def index
      @settings = Setting.by_query(s_params[:query]).ordered_by(s_params[:order_field])
      @number_of_pages = (@settings.count.to_f / settings_per_page).ceil
      @settings = @settings.paginated(s_params[:page], settings_per_page)
      fresh_when(@settings)
    end
    # rubocop:enable AbcSize

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

    def reset
      respond_to do |format|
        @setting, @successful_update = Setting.reset(s_params[:name])
        format.js { render :update }
      end
    end

    private

    def settings_per_page
      if params[:monitor_mode] == Sail::ConstantCollection::TRUE
        Sail::ConstantCollection::MINIMAL_SETTINGS_PER_PAGE
      else
        Sail::ConstantCollection::SETTINGS_PER_PAGE
      end
    end

    def s_params
      params.permit(:page, :query, :name,
                    :value, :positive, :negative,
                    :throttled_by, :order_field)
    end

    def log_update
      message = +"#{DateTime.now.utc.strftime("%Y/%m/%d %H:%M")} [Sail] #{action_name.capitalize} setting='#{@setting.name}' " \
                 "value='#{@setting.value}'"

      message << " author_user_id=#{current_user.id}" if current_user
      Rails.logger.info(message)
    end
  end
end
