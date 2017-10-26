# frozen_string_literal: true
module Sail
  class ClustersController < ApplicationController
    before_action :set_all_models, only: %i(new)
    rescue_from ActionController::ParameterMissing do |e|
      render plain: e.message, status: :bad_request
    end

    def new
    end

    def report
      render(partial: 'report')
    end

    def columns
      columns = columns_params[:model].classify.safe_constantize&.column_names - %w(id)

      respond_to do |f|
        f.json { render json: columns.map(&:capitalize), status: :ok }
      end
    end

    private

    def set_all_models
      @models = Dir["#{Rails.root}/app/models/**/*"]
                    .reject { |path| path.include?('concerns') || path.include?('application_record') || File.directory?(path)  }
                    .flat_map do |model_path|


        model_path
            .gsub("#{Rails.root}/app/models/", '')
            .gsub('.rb', '')
            .titleize
            .gsub('/', '::')
            .delete(' ')
      end.sort
    end

    def columns_params
      params.permit(:model).tap do |p|
        p.require(:model)
      end
    end
  end
end
