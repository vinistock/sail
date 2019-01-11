#!/usr/bin/env rake
# frozen_string_literal: true

begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), "tasks/**/*.rake")].each { |f| load f }

require "rspec/core"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(spec: "app:db:test:prepare")
task default: :spec

task :all do
  system("brakeman && rake && rubocop && rails_best_practices")
end

system("cd ./spec/dummy; RAILS_ENV=test rails db:environment:set; cd ../..") if Rails::VERSION::MAJOR >= 5
