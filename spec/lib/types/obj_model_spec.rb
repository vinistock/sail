# frozen_string_literal: true

describe Sail::Types::ObjModel, type: :lib do
  describe "#to_value" do
    subject { described_class.new(setting).to_value }

    let(:setting) { Sail::Setting.create!(name: :setting, cast_type: :obj_model, value: "Test") }

    it { is_expected.to eq(Test) }
  end
end
