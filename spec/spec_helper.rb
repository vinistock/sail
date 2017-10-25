# frozen_string_literal: true
require 'bundler/setup'
require 'byebug'
require 'simplecov'
require 'rails/all'
require 'sail'

SimpleCov.start

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
