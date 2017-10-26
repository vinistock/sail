# frozen_string_literal: true
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'bundler/setup'
require 'byebug'
require 'rspec/rails'
require 'simplecov'
require 'rails/all'
require 'sail'

SimpleCov.start

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.infer_spec_type_from_file_location!
  config.order = :random
end
