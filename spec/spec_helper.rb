# frozen_string_literal: true
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'bundler/setup'
require 'byebug'
require 'rspec/rails'
require 'simplecov'
require 'rails/all'
require 'database_cleaner'
require 'sail'

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
end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Schema.define do
  create_table :sail_settings, force: true do |t|
    t.string :name, null: false
    t.text :description
    t.string :value, null: false
    t.integer :cast_type, null: false, limit: 1
    t.timestamps
    t.index ["name"], name: "index_settings_on_name", unique: true
  end
end
