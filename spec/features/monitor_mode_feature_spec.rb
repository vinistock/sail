# frozen_string_literal: true

feature "monitor mode", js: true, type: :feature do
  let!(:setting) do
    Sail::Setting.create!(name: "setting", cast_type: :string,
                          value: :something,
                          description: "Setting that does something",
                          group: "feature_flags")
  end

  before do
    visit "/sail"
  end

  it "displays setting with minimalistic card" do
    expect_setting(setting)

    click_link("Monitor mode")

    within(".card") do
      expect(page).to have_text(setting.name.titleize)
      expect(page).to have_text(setting.value)
      expect(page).to have_no_text(setting.description.capitalize)
      expect(page).to have_no_text(setting.cast_type)
      expect(page).to have_no_text(setting.group)
      expect(page).to have_no_field("value")
    end

    click_link("Regular mode")

    expect_setting(setting)
  end

  it "allows viewing guide" do
    click_link("Monitor mode")
    click_button("Guide")

    expect(page).to have_content("Reference Guide")
    find("body").native.send_keys(:escape)
    expect(page).to have_no_css("#guide-modal", visible: true)
  end

  context "when there is more than one page" do
    before do
      24.times do |index|
        Sail::Setting.create!(name: "setting_#{index}", cast_type: :string,
                              value: :something,
                              description: "Setting that does something",
                              group: "feature_flags")
      end
    end

    it "allows navigating through pages" do
      click_link("Monitor mode")
      expect(all(".card").count).to eq(24)
      click_link("2")
      expect(all(".card").count).to eq(1)
    end
  end
end
