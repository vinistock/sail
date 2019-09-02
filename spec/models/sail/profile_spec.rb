# frozen_string_literal: true

describe Sail::Profile, type: :model do
  let!(:setting_1) { Sail::Setting.create!(name: :setting_1, cast_type: :integer, value: 1) }
  let!(:setting_2) { Sail::Setting.create!(name: :setting_2, cast_type: :integer, value: 2) }

  describe "callbacks" do
    describe "destroy" do
      subject(:destroy) { profile.destroy }

      let!(:profile) { described_class.create_or_update_self(:profile).first }

      it "destroys entries as well" do
        expect { destroy }.to change(Sail::Entry, :count).by(-2)
      end
    end
  end

  describe "validations" do
    describe "only_one_active_profile" do
      it "prevents two or more active profiles" do
        described_class.create_or_update_self(:profile)
        profile = described_class.new(name: "new_profile", active: true)
        expect(profile).to be_invalid
      end

      it "allows regular profile activation" do
        profile = described_class.new(name: "new_profile", active: true)
        expect(profile).to be_valid
      end
    end
  end

  describe ".create_or_update_self" do
    subject(:create_or_update_self) { described_class.create_or_update_self(:profile) }

    it "creates entries for each setting" do
      expect { create_or_update_self }.to change(Sail::Entry, :count).by(2)
    end

    it "creates the profile" do
      expect { create_or_update_self }.to change(Sail::Profile, :count).by(1)
    end

    it "saves entries with current setting values" do
      create_or_update_self
      expect(Sail::Entry.find_by(setting: setting_1).value).to eq(setting_1.value)
      expect(Sail::Entry.find_by(setting: setting_2).value).to eq(setting_2.value)
    end

    it "updates values if profile already exists" do
      create_or_update_self
      expect(setting_1.entries.first.value).to eq("1")
      setting_1.update!(value: "5")

      expect { described_class.create_or_update_self(:profile) }.to change(Sail::Profile, :count).by(0)
      expect(setting_1.entries.reload.first.value).to eq("5")
    end
  end

  describe ".switch" do
    subject(:switch) { described_class.switch(:profile_1) }

    let(:profile_1) { Sail::Profile.find_by(name: :profile_1) }
    let(:profile_2) { Sail::Profile.find_by(name: :profile_2) }

    before do
      Sail::Profile.create_or_update_self(:profile_1)
      Sail.set(:setting_1, 3)
      Sail.set(:setting_2, 5)
      Sail::Profile.create_or_update_self(:profile_2)
    end

    it "switches between two profiles" do
      expect(profile_1.active).to be_falsey
      expect(profile_2.active).to be_truthy
      expect(setting_1.reload.value).to eq("3")
      expect(setting_2.reload.value).to eq("5")
      switch
      expect(setting_1.reload.value).to eq("1")
      expect(setting_2.reload.value).to eq("2")
      expect(profile_1.reload.active).to be_truthy
      expect(profile_2.reload.active).to be_falsey
    end
  end

  describe "#dirty?" do
    subject { profile.dirty? }

    let!(:profile) { Sail::Profile.create_or_update_self(:profile).first }

    it { is_expected.to be_falsey }

    context "when a setting has been changed" do
      before do
        Sail.set(:setting_1, 3)
        profile.reload
      end

      it { is_expected.to be_truthy }
    end
  end
end
