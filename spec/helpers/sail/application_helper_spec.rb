# frozen_string_literal: true

describe Sail::ApplicationHelper, type: :helper do
  include described_class

  describe "#main_app" do
    subject { main_app }

    it "returns the URL helper for the main application" do
      expect(subject).to respond_to(:root_path)
    end
  end

  describe "#formatted_date" do
    subject { formatted_date(setting) }
    let!(:setting) { Sail::Setting.create(name: "setting", cast_type: :date, value: "2019-01-01 10:00") }

    it "formats date for input" do
      expect(subject).to eq("2019-01-01T10:01:00")
    end
  end

  describe "#settings_container_class" do
    subject { settings_container_class(pages) }

    context "when there's a page or more" do
      let(:pages) { 1 }
      it { is_expected.to eq("") }
    end

    context "when there are no pages" do
      let(:pages) { 0 }
      it { is_expected.to eq("empty") }
    end
  end
end
