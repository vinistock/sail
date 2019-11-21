# frozen_string_literal: true

# :nocov:
module Sail
  # Graphql
  #
  # Module to include type definitions
  # for GraphQL APIs.
  module Graphql
    extend ActiveSupport::Concern

    included do
      field :sail_get, ::GraphQL::Types::JSON, null: true do
        description "Returns the value for a given setting."
        argument :name, String, required: true, description: "The setting's name."
      end

      def sail_setting(name:)
        Sail.get(name)
      end
    end
  end
end
# :nocov:
