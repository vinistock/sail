# frozen_string_literal: true

describe FalseClass, type: :lib do
  describe "#to_s" do
    subject { false.to_s }
    it { is_expected.to eq("false") }
  end
end
