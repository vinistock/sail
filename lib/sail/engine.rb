module Sail
  class Engine < ::Rails::Engine
    isolate_namespace Sail

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
