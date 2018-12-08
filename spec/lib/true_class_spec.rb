# frozen_string_literal: true

describe TrueClass, type: :lib do
  describe "#to_s" do
    subject { true.to_s }
    it { is_expected.to eq("true") }
  end
end
