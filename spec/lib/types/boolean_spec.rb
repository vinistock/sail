# frozen_string_literal: true

describe Sail::Types::Boolean, type: :lib do
  let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :boolean, value: "true") }

  describe "#to_value" do
    subject { described_class.new(setting).to_value }
    it { is_expected.to eq(true) }
  end

  describe "#from" do
    subject { described_class.new(setting).from(value) }

    context "when value is a Boolean as a string" do
      let(:value) { "true" }
      it { is_expected.to eq("true") }
    end

    context "when value is the string on" do
      let(:value) { "on" }
      it { is_expected.to eq("true") }
    end

    context "when value is a Boolean" do
      let(:value) { true }
      it { is_expected.to eq("true") }
    end

    context "when value is nil" do
      let(:value) { nil }
      it { is_expected.to eq("false") }
    end
  end
end
