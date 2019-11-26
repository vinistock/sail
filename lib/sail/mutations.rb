# frozen_string_literal: true

# :nocov:
module Sail
  module Graphql
    module Mutations # :nodoc:
      extend ActiveSupport::Concern

      included do
        field :sail_set, mutation: SailSet do
          description "Set the value for a setting."
          argument :name, String, required: true
          argument :value, String, required: true
        end

        field :sail_profile_switch, mutation: SailProfileSwitch do
          description "Switches to the chosen profile."
          argument :name, String, required: true
        end
      end

      class SailSet < ::GraphQL::Schema::Mutation # :nodoc:
        argument :name, String, required: true
        argument :value, String, required: true

        field :success, Boolean, null: false

        def resolve(name:, value:)
          _, success = Sail.set(name, value)
          { success: success }
        end
      end

      class SailProfileSwitch < ::GraphQL::Schema::Mutation # :nodoc:
        argument :name, String, required: true

        field :success, Boolean, null: false

        def resolve(name:)
          success = Profile.exists?(name: name)
          Profile.switch(name)

          { success: success }
        end
      end
    end
  end
end
# :nocov:
