# frozen_string_literal: true

require 'rails/generators/named_base'

module Sail
  module Generators
    class SailGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      namespace 'sail'
      source_root File.expand_path('../templates', __FILE__)
      desc 'Generates Sail settings migration file'
      hook_for :orm
    end
  end
end
