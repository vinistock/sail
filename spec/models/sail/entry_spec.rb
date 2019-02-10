# frozen_string_literal: true

describe Sail::Entry, type: :model do
  describe "scopes" do
    describe ".by_profile_name" do
      subject { described_class.by_profile_name(:profile) }

      let!(:profile_1) { Sail::Profile.create!(name: :profile) }
      let!(:setting_1) { Sail::Setting.create!(name: :setting, cast_type: :integer, value: 1) }
      let!(:entry_1) { Sail::Entry.create!(setting: setting_1, profile: profile_1, value: 2) }

      let!(:profile_2) { Sail::Profile.create!(name: :profile_2) }
      let!(:setting_2) { Sail::Setting.create!(name: :setting_2, cast_type: :integer, value: 1) }
      let!(:entry_2) { Sail::Entry.create!(setting: setting_2, profile: profile_2, value: 5) }

      it { is_expected.to include(entry_1) }
      it { is_expected.to_not include(entry_2) }
    end
  end

  describe "#name" do
    subject { entry_1.name }

    let!(:profile_1) { Sail::Profile.create!(name: :profile) }
    let!(:setting_1) { Sail::Setting.create!(name: :setting, cast_type: :integer, value: 1) }
    let!(:entry_1) { Sail::Entry.create!(setting: setting_1, profile: profile_1, value: 2) }

    it { is_expected.to eq(setting_1.name) }
  end
end
