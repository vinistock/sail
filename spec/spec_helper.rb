# frozen_string_literal: true
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'bundler/setup'
require 'byebug'
require 'rspec/rails'
require 'simplecov'
require 'rails/all'
require 'database_cleaner'
require 'capybara/rspec'
require 'capybara/rails'
require 'sail'
require 'selenium/webdriver'

SimpleCov.start
DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.infer_spec_type_from_file_location!
  config.order = :random

  config.before(:each) do
    DatabaseCleaner.clean
  end

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :headless_chrome do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(chromeOptions: { args: %w(headless disable-gpu) })
    Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
  end

  Capybara.javascript_driver = :headless_chrome
  Capybara.server = :webrick
end
