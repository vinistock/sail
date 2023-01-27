# frozen_string_literal: true

source "https://rubygems.org"
gemspec

rails_version = ENV.fetch("RAILS_VERSION", nil)

gem "bundler"
gem "byebug", platforms: %i[mri mingw x64_mingw]
gem "capybara"
gem "capybara-selenium"
gem "database_cleaner"
gem "rack-mini-profiler"
gem "rails", (rails_version || ">= 4.0.0")
gem "rspec-rails", (rails_version.nil? || rails_version.to_s >= "6.0.0" ? ">= 4.0.0" : ">= 3.8.0")
gem "rspec-retry"
gem "rubocop"
gem "rubocop-packaging"
gem "rubocop-performance"
gem "rubocop-rails"
gem "sassc-rails"
gem "sqlite3",
    (rails_version.nil? || rails_version.to_s >= "6.0.0" ? ">= 1.4.0" : "< 1.4.0"),
    platforms: %i[mri mingw x64_mingw]
gem "webdrivers"
gem "webrick"
