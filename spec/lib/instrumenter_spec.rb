# frozen_string_literal: true

describe Sail::Instrumenter, type: :lib do
  describe ".initialize" do
    subject { described_class.new }

    it "sets default instrumenter values" do
      expect(subject.instance_variable_get(:@statistics)).to eq("settings" => {}, "profiles" => {})
    end
  end

  describe "#increment_usage_of" do
    subject { instrumenter.increment_usage_of("setting") }
    let(:instrumenter) { described_class.new }

    it "increments usage count" do
      expect(instrumenter.instance_variable_get(:@statistics)).to eq("settings" => {}, "profiles" => {})

      subject
      expect(instrumenter.instance_variable_get(:@statistics)).to eq("settings" => { "setting" => { "usages" => 1, "failures" => 0 } },
                                                                     "profiles" => {})
    end

    it "deletes cache fragment after reaching increment limit" do
      expect_any_instance_of(ActionController::Base).to receive(:expire_fragment).with(/name: "setting"/)
      500.times { instrumenter.increment_usage_of("setting") }
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

    context "when statistics are still empty" do
      before do
        instrumenter.instance_variable_set(:@statistics, { settings: {}, profiles: {} }.with_indifferent_access)
      end

      it { is_expected.to be_zero }
    end
  end

  describe "#increment_failure_of" do
    subject { instrumenter.increment_failure_of("setting") }
    let(:instrumenter) { described_class.new }

    it "increments failure count" do
      expect(instrumenter.instance_variable_get(:@statistics)).to eq("settings" => {}, "profiles" => {})

      subject
      expect(instrumenter.instance_variable_get(:@statistics)).to eq("settings" => { "setting" => { "usages" => 0, "failures" => 1 } },
                                                                     "profiles" => {})
    end

    it "resets setting after 50 failures" do
      expect(Sail).to receive(:reset).with("setting")

      51.times { instrumenter.increment_failure_of("setting") }
    end

    context "when there is an active profile" do
      before { Sail::Profile.create!(name: "profile", active: true) }

      it "increments profile failure count as well" do
        expect(instrumenter.instance_variable_get(:@statistics)).to eq("settings" => {}, "profiles" => {})

        subject
        expect(instrumenter.instance_variable_get(:@statistics)).to eq("settings" => { "setting" => { "usages" => 0, "failures" => 1 } },
                                                                       "profiles" => { "profile" => 1 })
      end
    end
  end

  describe "#increment_profile_failure_of" do
    subject { instrumenter.increment_profile_failure_of("profile") }
    let(:instrumenter) { described_class.new }

    it "increments failure count" do
      expect(instrumenter.instance_variable_get(:@statistics)).to eq("settings" => {}, "profiles" => {})

      subject
      expect(instrumenter.instance_variable_get(:@statistics)).to eq("settings" => {},
                                                                     "profiles" => { "profile" => 1 })
    end
  end

  describe "#profile" do
    let(:instrumenter) { described_class.new }

    it "returns profile information" do
      expect(instrumenter.profile("profile")).to be_zero
      instrumenter.increment_profile_failure_of("profile")
      expect(instrumenter.profile("profile")).to eq(1)
    end
  end
end
