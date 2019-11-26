# frozen_string_literal: true

# :nocov:
module Sail
  # Graphql
  #
  # Module to include type definitions
  # for GraphQL APIs.
  module Graphql
    module Types
      extend ActiveSupport::Concern

      included do
        field :sail_get, ::GraphQL::Types::JSON, null: true do
          description "Returns the value for a given setting."
          argument :name, String, required: true, description: "The setting's name."
        end

        field :sail_switcher, ::GraphQL::Types::JSON, null: true do
          description "Switches between the positive or negative setting based on the throttle."
          argument :positive, String, required: true, description: "The setting's name if the throttle is bigger than the desired amount."
          argument :negative, String, required: true, description: "The setting's name if the throttle is smaller than the desired amount."
          argument :throttled_by, String, required: true, description: "The throttle setting's name."
        end

        def sail_get(name:)
          Sail.get(name)
        end

        def sail_switcher(positive:, negative:, throttled_by:)
          Sail.switcher(
            positive: positive,
            negative: negative,
            throttled_by: throttled_by
          )
        end
      end
    end
  end
end
# :nocov:
