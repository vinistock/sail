# frozen_string_literal: true

module Sail
  class Engine < ::Rails::Engine
    require 'jquery-rails'
    isolate_namespace Sail

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
