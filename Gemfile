# frozen_string_literal: true

source "https://rubygems.org"
gemspec

jruby_sqlite3_adapter = if ENV["RAILS_VERSION"].nil? || ENV["RAILS_VERSION"].to_s >= "6.0.0"
                          ">= 52.3"
                        else
                          ">= 50.0"
                        end

gem "activerecord-jdbcsqlite3-adapter", jruby_sqlite3_adapter, platform: :jruby
gem "byebug", platforms: %i[mri mingw x64_mingw]
gem "codecov", require: false, group: :test unless ENV["ON_CI"].nil?
gem "sassc-rails"
gem "rails", (ENV["RAILS_VERSION"] || ">= 4.0.0") # rubocop:disable Bundler/OrderedGems
gem "rspec-rails", (ENV["RAILS_VERSION"].nil? || ENV["RAILS_VERSION"].to_s >= "6.0.0" ? "4.0.0.beta2" : ">= 3.8.0")
gem "sqlite3",
    (ENV["RAILS_VERSION"].nil? || ENV["RAILS_VERSION"].to_s >= "6.0.0" ? ">= 1.4.0" : "< 1.4.0"),
    platforms: %i[mri mingw x64_mingw]
