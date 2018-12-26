# frozen_string_literal: true

describe Sail, type: :lib do
  describe ".get" do
    subject { described_class.get("name") }

    it "delegates to setting" do
      expect(Sail::Setting).to receive(:get).with("name")
      subject
    end
  end

  describe ".set" do
    subject { described_class.set("name", "value") }

    it "delegates to setting" do
      expect(Sail::Setting).to receive(:set).with("name", "value")
      subject
    end
  end

  describe ".switcher" do
    subject { described_class.switcher(positive: "positive", negative: "negative", throttled_by: "throttle") }

    it "delegates to setting" do
      expect(Sail::Setting).to receive(:switcher).with(positive: "positive", negative: "negative", throttled_by: "throttle")
      subject
    end
  end

  describe ".reset" do
    subject { described_class.reset("name") }

    it "delegates to setting" do
      expect(Sail::Setting).to receive(:reset).with("name")
      subject
    end
  end
end
