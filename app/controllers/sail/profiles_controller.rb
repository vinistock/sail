# frozen_string_literal: true

require_dependency "sail/application_controller"

module Sail
  # ProfilesController
  #
  # This controller implements all profile related
  # APIs.
  class ProfilesController < ApplicationController
    def create
      respond_to do |format|
        format.js do
          @profile, @new_record = Sail::Profile.create_or_update_self(s_params[:name])
        end
      end
    end

    def switch
      respond_to do |format|
        format.js do
          Sail::Profile.switch(s_params[:name])
        end
      end
    end

    def destroy
      respond_to do |format|
        format.js do
          @profile = Sail::Profile.find_by(name: s_params[:name]).destroy
        end
      end
    end

    private

    def s_params
      params.permit(:name)
    end
  end
end
