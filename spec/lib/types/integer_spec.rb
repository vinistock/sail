# frozen_string_literal: true

describe Sail::Types::Integer, type: :lib do
  describe "#to_value" do
    subject { described_class.new(setting).to_value }

    let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :integer, value: "5") }

    it { is_expected.to eq(5) }
  end
end
