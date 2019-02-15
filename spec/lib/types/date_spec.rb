# frozen_string_literal: true

describe Sail::Types::Date, type: :lib do
  describe "#to_value" do
    subject { described_class.new(setting).to_value }

    let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :date, value: "2019-01-01 10:00") }

    it { is_expected.to eq(DateTime.parse("2019-01-01 10:00").utc) }
  end
end
