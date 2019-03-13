# frozen_string_literal: true

describe Sail::Types::Cron, type: :lib do
  describe "#to_value" do
    subject { described_class.new(setting).to_value }

    let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :cron, value: "0 * * * *") }

    before do
      allow(DateTime).to receive(:now).and_return(DateTime.parse(date_string).utc)
    end

    context "when cron matches" do
      let(:date_string) { "2018-10-05 20:00" }
      it { is_expected.to be_truthy }
    end

    context "when cron does not match" do
      let(:date_string) { "2018-10-05 20:02" }
      it { is_expected.to be_falsey }
    end
  end
end
