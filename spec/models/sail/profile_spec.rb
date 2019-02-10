# frozen_string_literal: true

describe Sail::Profile, type: :model do
  let!(:setting_1) { Sail::Setting.create!(name: :setting_1, cast_type: :integer, value: 1) }
  let!(:setting_2) { Sail::Setting.create!(name: :setting_2, cast_type: :integer, value: 2) }

  describe "callbacks" do
    describe "destroy" do
      subject(:destroy) { profile.destroy }

      let!(:profile) { described_class.create_self(:profile) }

      it "destroys entries as well" do
        expect { destroy }.to change(Sail::Entry, :count).by(-2)
      end
    end
  end

  describe ".create_self" do
    subject(:create_self) { described_class.create_self(:profile) }

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

  describe ".switch" do
    subject(:switch) { described_class.switch(:profile) }

    before do
      Sail::Profile.create_self(:profile)
      Sail.set(:setting_1, 3)
      Sail.set(:setting_2, 5)
    end

    it "switches between two profiles" do
      expect(setting_1.reload.value).to eq("3")
      expect(setting_2.reload.value).to eq("5")
      switch
      expect(setting_1.reload.value).to eq("1")
      expect(setting_2.reload.value).to eq("2")
    end
  end
end
