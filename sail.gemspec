# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "sail/version"
Gem::Specification.new do |s|
  s.name        = "sail"
  s.version     = Sail::VERSION
  s.authors     = ["Vinicius Stock"].freeze
  s.email       = ["vinicius.stock@outlook.com"].freeze
  s.homepage    = "https://github.com/vinistock/sail"
  s.summary     = "Sail is a lightweight Rails engine that brings an admin panel for managing configuration settings on a live Rails app."
  s.description = "Sail is a lightweight Rails engine that brings an admin panel for managing configuration settings on a live Rails app."
  s.license     = "MIT"

  s.files = Dir["{app,config,lib}/**/*",
                "MIT-LICENSE",
                "Rakefile",
                "README.md"].reject { |path| path.include?("sail.gif") }

  s.required_ruby_version = ">= 2.5.0"

  s.add_dependency "fugit"
  s.add_dependency "rails", ">= 5.0.0"

  s.add_development_dependency "brakeman"
  s.add_development_dependency "bundler"
  s.add_development_dependency "capybara"
  s.add_development_dependency "capybara-selenium"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "rack-mini-profiler"
  s.add_development_dependency "rails_best_practices"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-retry"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "rubocop-performance"
  s.add_development_dependency "rubocop-rails"
  s.add_development_dependency "simplecov", "~> 0.18.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "webdrivers"
end
