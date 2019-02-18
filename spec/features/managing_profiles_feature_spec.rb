# frozen_string_literal: true

feature "managing profiles", js: true, type: :feature do
  let!(:setting_1) do
    Sail::Setting.create(name: :setting, cast_type: :string,
                         value: :something)
  end

  let!(:setting_2) do
    Sail::Setting.create(name: :configuration, cast_type: :string,
                         value: :something)
  end

  before do
    visit "/sail"
    find("#btn-profiles").click
  end

  it "allows closing modal using escape" do
    expect(page).to have_css("#profiles-modal", visible: true)
    find("body").native.send_keys(:escape)
    expect(page).to have_css("#profiles-modal", visible: false)
  end

  it "allows creating new profiles" do
    within("#profiles-modal") do
      expect(Sail::Profile.count).to be_zero
      fill_in("new-profile-input", with: "Profile 1")
      click_button("SAVE")
      expect(page).to have_content("Created")
      expect(page).to have_content("Profile 1")
      expect(page).to have_button("ACTIVATE")
      expect(page).to have_button("DELETE")
      expect(Sail::Profile.count).to eq(1)

      entries = Sail::Profile.first.entries
      expect([setting_1, setting_2]).to include(entries.first.setting)
      expect([setting_1, setting_2]).to include(entries.second.setting)
    end
  end

  it "allows activating profiles" do
    within("#profiles-modal") do
      expect(Sail::Profile.count).to be_zero
      fill_in("new-profile-input", with: "Profile 1")
      click_button("SAVE")
      expect(page).to have_content("Created")
      expect(page).to have_content("Profile 1")
      expect(page).to have_button("ACTIVATE")
      expect(page).to have_button("DELETE")
      expect(Sail::Profile.count).to eq(1)

      setting_1.update_attributes!(value: :something_else)

      click_button("ACTIVATE")
      expect(page).to have_content("Switched")
      expect(page).to have_content("Profile 1")
      expect(page).to have_button("ACTIVATE")
      expect(page).to have_button("DELETE")
      expect(setting_1.reload.value).to eq("something")
    end
  end

  it "allows deleting profiles" do
    within("#profiles-modal") do
      expect(Sail::Profile.count).to be_zero
      fill_in("new-profile-input", with: "Profile 1")
      click_button("SAVE")
      expect(page).to have_content("Created")
      expect(page).to have_content("Profile 1")
      expect(page).to have_button("ACTIVATE")
      expect(page).to have_button("DELETE")
      expect(Sail::Profile.count).to eq(1)

      click_button("DELETE")
      expect(page).to have_content("Deleted")
      expect(page).to have_no_content("Profile 1")
      expect(page).to have_no_button("ACTIVATE")
      expect(page).to have_no_button("DELETE")
      expect(Sail::Profile.count).to be_zero
    end
  end

  it "allows saving existing profiles" do
    within("#profiles-modal") do
      expect(Sail::Profile.count).to be_zero
      fill_in("new-profile-input", with: "Profile 1")
      click_button("SAVE")
      expect(page).to have_content("Created")
      expect(page).to have_content("Profile 1")
      expect(page).to have_button("ACTIVATE")
      expect(page).to have_button("DELETE")
      expect(Sail::Profile.count).to eq(1)

      setting_1.update_attributes!(value: :something_else)

      within(all(".profile-entry")[1]) do
        click_button("SAVE")
      end

      expect(page).to have_content("Saved")
      expect(page).to have_content("Profile 1")
      expect(page).to have_button("ACTIVATE")
      expect(page).to have_button("DELETE")
      expect(Sail::Profile.count).to eq(1)
    end
  end
end
