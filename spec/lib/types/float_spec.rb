# frozen_string_literal: true

describe Sail::Types::Float, type: :lib do
  describe "#to_value" do
    subject { described_class.new(setting).to_value }

    let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :float, value: "3.123") }

    it { is_expected.to eq(3.123) }
  end
end
