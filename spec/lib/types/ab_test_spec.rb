# frozen_string_literal: true

describe Sail::Types::AbTest, type: :lib do
  describe "#to_value" do
    subject(:to_value) { described_class.new(setting).to_value }

    let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :ab_test, value: value) }

    context "when value is true" do
      let(:value) { "true" }
      it { expect([true, false]).to include(to_value) }
    end

    context "when value is false" do
      let(:value) { "false" }
      it { is_expected.to be_falsey }
    end
  end
end
