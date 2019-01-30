# frozen_string_literal: true

describe Sail::Instrumenter, type: :lib do
  describe ".initialize" do
    subject { described_class.new }

    it "sets default instrumenter values" do
      expect(subject.instance_variable_get(:@statistics)).to eq({})
    end
  end

  describe "#increment_usage_of" do
    subject { instrumenter.increment_usage_of("setting") }
    let(:instrumenter) { described_class.new }

    it "increments usage count" do
      expect(instrumenter.instance_variable_get(:@statistics)).to eq({})

      subject
      expect(instrumenter.instance_variable_get(:@statistics)).to eq("setting" => 1)
    end
  end

  describe "#relative_usage_of" do
    subject { instrumenter.relative_usage_of("setting") }
    let(:instrumenter) { described_class.new }

    before do
      instrumenter.increment_usage_of("setting")
      instrumenter.increment_usage_of("setting")
      instrumenter.increment_usage_of("setting_2")
      instrumenter.increment_usage_of("setting_2")
    end

    it "calculates percentage ratio of usage" do
      expect(subject).to eq(50.0)
    end
  end
end
