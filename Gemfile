# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "byebug", platforms: %i[mri mingw x64_mingw]
gem "codecov", require: false, group: :test unless ENV["ON_CI"].nil?
gem "sassc-rails"
gem "rails", (ENV["RAILS_VERSION"] || ">= 4.0.0") # rubocop:disable Bundler/OrderedGems
gem "rspec-rails", (ENV["RAILS_VERSION"].nil? || ENV["RAILS_VERSION"].to_s >= "6.0.0" ? "4.0.0.beta3" : ">= 3.8.0")
gem "sqlite3",
    (ENV["RAILS_VERSION"].nil? || ENV["RAILS_VERSION"].to_s >= "6.0.0" ? ">= 1.4.0" : "< 1.4.0"),
    platforms: %i[mri mingw x64_mingw]
