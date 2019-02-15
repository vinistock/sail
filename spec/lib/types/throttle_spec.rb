# frozen_string_literal: true

describe Sail::Types::Throttle, type: :lib do
  describe "#to_value" do
    subject(:to_value) { described_class.new(setting).to_value }

    let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :throttle, value: "30") }

    it { expect([true, false]).to include(to_value) }
  end
end
