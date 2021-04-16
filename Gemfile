# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "byebug", platforms: %i[mri mingw x64_mingw]
gem "rails", (ENV["RAILS_VERSION"] || ">= 4.0.0")
gem "rspec-rails", (ENV["RAILS_VERSION"].nil? || ENV["RAILS_VERSION"].to_s >= "6.0.0" ? ">= 4.0.0" : ">= 3.8.0")
gem "sassc-rails"
gem "sqlite3",
    (ENV["RAILS_VERSION"].nil? || ENV["RAILS_VERSION"].to_s >= "6.0.0" ? ">= 1.4.0" : "< 1.4.0"),
    platforms: %i[mri mingw x64_mingw]
gem "webrick"
