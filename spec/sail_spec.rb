# frozen_string_literal: true

describe Sail, type: :lib do
  describe ".get" do
    subject { described_class.get("name") }

    it "delegates to setting" do
      expect(Sail::Setting).to receive(:get).with("name")
      subject
    end

    it "allows using settings in block format" do
      allow(Sail::Setting).to receive(:get).with("name").and_return("something")

      described_class.get("name") do |setting_value|
        expect(setting_value).to eq("something")
      end
    end

    context "when passing expected errors" do
      subject { described_class.get("name", expected_errors: [ArgumentError]) }

      context "and the expected error occurs" do
        before do
          allow(Sail::Setting).to receive(:get).with("name").and_raise(ArgumentError)
        end

        it "does not increment failure count" do
          expect_any_instance_of(Sail::Instrumenter).not_to receive(:increment_failure_of).with("name")

          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "and an unexpected error occurs" do
        before do
          allow(Sail::Setting).to receive(:get).with("name").and_raise(StandardError)
        end

        it "increments failure count" do
          expect_any_instance_of(Sail::Instrumenter).to receive(:increment_failure_of).with("name")

          expect { subject }.to raise_error(StandardError)
        end
      end

      context "when not passing expected errors but an error occurs" do
        subject { described_class.get("name") }

        before do
          allow(Sail::Setting).to receive(:get).with("name").and_raise(StandardError)
        end

        it "does not increment failure count" do
          expect_any_instance_of(Sail::Instrumenter).not_to receive(:increment_failure_of).with("name")

          expect { subject }.to raise_error(StandardError)
        end
      end
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
