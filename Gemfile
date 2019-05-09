# frozen_string_literal: true

source "https://rubygems.org"
gemspec

gem "capybara", "< 3.19.0" unless ENV["TRAVIS_RUBY_VERSION"].nil? || ENV["TRAVIS_RUBY_VERSION"] >= "2.4.0"
gem "rails", (ENV["RAILS_VERSION"] || ">= 4.0.0")
