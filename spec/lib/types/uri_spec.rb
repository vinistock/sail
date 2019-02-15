# frozen_string_literal: true

describe Sail::Types::Uri, type: :lib do
  describe "#to_value" do
    subject { described_class.new(setting).to_value }

    let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :uri, value: "https://google.com") }

    it { is_expected.to eq(URI.parse("https://google.com")) }
  end
end
