# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"
require File.expand_path("dummy/config/environment.rb", __dir__)
require "rspec/rails"
require "simplecov"
require "rails/all"
require "database_cleaner"
require "capybara/rspec"
require "capybara/rails"
require "sail"
require "selenium/webdriver"
require "webdrivers/geckodriver"
require "rspec/retry"

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

  config.around :each, :js do |ex|
    ex.run_with_retry retry: 3
  end

  Capybara.javascript_driver = :selenium_headless
  Capybara.server = :webrick
  Capybara.default_max_wait_time = 5
  Webdrivers.install_dir = "~/bin/firefox_driver" if ENV["ON_CI"].present?
end

# rubocop:disable Metrics/AbcSize
def expect_setting(setting)
  expect(page).to have_text(setting.name.titleize)
  expect(page).to have_text(setting.cast_type)
  expect(page).to have_link(setting.group)
  expect(page).to have_button("SAVE", disabled: true)

  if setting.boolean? || setting.ab_test?
    expect(page).to have_css(".slider")
  else
    expect(page).to have_field("value")
  end
end
# rubocop:enable Metrics/AbcSize
