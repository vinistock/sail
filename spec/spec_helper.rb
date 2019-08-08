# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
require File.expand_path("dummy/config/environment.rb", __dir__)
require "bundler/setup"
require "byebug"
require "rspec/rails"
require "simplecov"
require "rails/all"
require "database_cleaner"
require "capybara/rspec"
require "capybara/rails"
require "sail"
require "selenium/webdriver"
require "webdrivers/chromedriver"

SimpleCov.start
DatabaseCleaner.strategy = :truncation

class User
  def admin?
    true
  end

  def id
    1
  end
end

class WardenObject
  def user
    User.new
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.infer_spec_type_from_file_location!
  config.order = :random

  config.before(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each, type: :controller) do
    controller.request.env["warden"] = WardenObject.new
  end

  config.before(:each, type: :feature) do
    allow_any_instance_of(Sail::ApplicationController).to receive(:current_user).and_return(User.new)
  end

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :headless_chrome do |app|
    options = ::Selenium::WebDriver::Chrome::Options.new

    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--window-size=1920,1180")
    options.add_argument("--disable-gpu")

    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.javascript_driver = :headless_chrome
  Capybara.server = :webrick
  Webdrivers.install_dir = "~/bin/chromedriver" if ENV["TRAVIS_RUBY_VERSION"].present?
end

# rubocop:disable AbcSize
def expect_setting(setting)
  expect(page).to have_text(setting.name.titleize)
  expect(page).to have_text(setting.description.capitalize)
  expect(page).to have_text(setting.cast_type)
  expect(page).to have_link(setting.group)
  expect(page).to have_button("SAVE")

  if setting.boolean? || setting.ab_test?
    expect(page).to have_css(".slider")
  else
    expect(page).to have_field("value")
  end
end
# rubocop:enable AbcSize

# Patch to avoid failures for
# Ruby 2.6.x combined with Rails 4.x.x
# More details in https://github.com/rails/rails/issues/34790
if RUBY_VERSION >= "2.6.0" && Rails.version < "5"
  module ActionController
    class TestResponse < ActionDispatch::TestResponse
      def recycle!
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  end
end
