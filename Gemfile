# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "byebug", platforms: %i[mri mingw x64_mingw]
gem "capybara", "< 3.19.0" unless ENV["TRAVIS_RUBY_VERSION"].nil? || ENV["TRAVIS_RUBY_VERSION"] >= "2.4.0"
gem "sassc-rails"
gem "rails", (ENV["RAILS_VERSION"] || ">= 4.0.0") # rubocop:disable Bundler/OrderedGems
gem "rspec-rails", (ENV["RAILS_VERSION"].nil? || ENV["RAILS_VERSION"].to_s >= "6.0.0" ? "4.0.0.beta2" : ">= 3.8.0")
gem "sqlite3", (ENV["RAILS_VERSION"].nil? || ENV["RAILS_VERSION"].to_s >= "6.0.0" ? ">= 1.4.0" : "< 1.4.0")
