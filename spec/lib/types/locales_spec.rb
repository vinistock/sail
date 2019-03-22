# frozen_string_literal: true

describe Sail::Types::Locales, type: :lib do
  let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :array, value: "en;es") }

  describe "#to_value" do
    subject { described_class.new(setting).to_value }

    before do
      I18n.locale = locale
    end

    context "when locale is included" do
      let(:locale) { :en }
      it { is_expected.to be_truthy }
    end

    context "when locale is not included" do
      let(:locale) { :fr }
      it { is_expected.to be_falsey }
    end
  end
end
