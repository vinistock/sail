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
        format.json do
          begin
            Sail::Profile.create_self(s_params[:name])
            head(:created)
          rescue ActiveRecord::RecordNotUnique
            head(:conflict)
          end
        end
      end
    end

    def switch
      respond_to do |format|
        format.json do
          Sail::Profile.switch(s_params[:name])
          head(:ok)
        end
      end
    end

    def destroy
      respond_to do |format|
        format.json do
          Sail::Profile.find_by(name: s_params[:name]).destroy
          head(:ok)
        end
      end
    end

    private

    def s_params
      params.permit(:name)
    end
  end
end
