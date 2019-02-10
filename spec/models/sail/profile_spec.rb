# frozen_string_literal: true

describe Sail::Profile, type: :model do
  describe ".create_self" do
    subject(:create_self) { described_class.create_self(:profile) }

    let!(:setting_1) { Sail::Setting.create!(name: :setting_1, cast_type: :integer, value: 1) }
    let!(:setting_2) { Sail::Setting.create!(name: :setting_2, cast_type: :integer, value: 2) }

    it "creates entries for each setting" do
      expect { create_self }.to change(Sail::Entry, :count).by(2)
    end

    it "creates the profile" do
      expect { create_self }.to change(Sail::Profile, :count).by(1)
    end

    it "saves entries with current setting values" do
      create_self
      expect(Sail::Entry.find_by(setting: setting_1).value).to eq(setting_1.value)
      expect(Sail::Entry.find_by(setting: setting_2).value).to eq(setting_2.value)
    end
  end
end
