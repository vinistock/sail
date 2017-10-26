# frozen_string_literal: true
module Sail
  class ClustersController < ApplicationController
    def new
    end

    def report
      render(partial: 'report')
    end
  end
end
