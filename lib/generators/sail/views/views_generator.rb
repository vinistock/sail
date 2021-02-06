# frozen_string_literal: true

module Sail
  module Generators
    # ViewsGenerator
    # Copies the customizable views to the main app
    class ViewsGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../../../app/views/sail", __dir__)
      desc "Copies customizable views to the parent application."

      def copy_views
        copy_file("settings/_setting.html.erb", "app/views/sail/settings/_setting.html.erb")
      end
    end
  end
end
