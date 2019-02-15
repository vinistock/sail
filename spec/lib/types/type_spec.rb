# frozen_string_literal: true

describe Sail::Types::Type, type: :lib do
  let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :string, value: "30") }

  describe "#to_value" do
    subject { described_class.new(setting).to_value }
    it { is_expected.to eq("30") }
  end

  describe "#from" do
    subject { described_class.new(setting).from("50") }
    it { is_expected.to eq("50") }
  end
end
