# frozen_string_literal: true

feature "viewing settings", js: true, type: :feature do
  before do
    20.times do |index|
      Sail::Setting.create!(name: "setting_#{index}", cast_type: :string,
                            value: :something,
                            description: "Setting that does something",
                            group: "feature_flags")
    end

    5.times do |index|
      Sail::Setting.create!(name: "setting_#{index + 20}", cast_type: :integer,
                            value: "5",
                            description: "Setting that does something",
                            group: "tuners",
                            updated_at: 75.days.ago)
    end
  end

  it "displays setting information and allows navigation" do
    visit "/sail"

    Sail::Setting.first(20).each { |setting| expect_setting(setting) }

    within("#pagination") do
      click_link("2")
    end

    Sail::Setting.last(5).each { |setting| expect_setting(setting) }

    find("#angle-left-link").click
    Sail::Setting.first(20).each { |setting| expect_setting(setting) }

    find("#angle-right-link").click
    Sail::Setting.last(5).each { |setting| expect_setting(setting) }
  end

  it "allows clicking on groups to filter" do
    visit "/sail"

    within(all(".card").first) do
      click_link("feature_flags")
    end

    expect(page).to have_css(".card", count: 20)
  end

  it "allows clicking on types to filter" do
    visit "/sail"

    within(all(".card").first) do
      click_link("string")
    end

    expect(page).to have_css(".card", count: 20)
  end

  it "allows clicking on stale to filter" do
    visit "/sail"
    find("#angle-right-link").click

    within(all(".card").last) do
      click_link("stale")
    end

    expect(page).to have_css(".card", count: 5)
  end

  it "has a main app link" do
    visit "/sail"

    expect(page).to have_css("#main-app-link", count: 1)
    find("#main-app-link").click
    expect(page).to have_text("Inside dummy app")
  end

  it "displays relevancy score" do
    Sail.instrumenter.instance_variable_set(:@statistics, { settings: {}, profiles: {} }.with_indifferent_access)
    2.times { Sail.get("setting_0") }
    2.times { Sail.get("setting_1") }

    visit "/sail"

    within(all(".card").first) do
      expect(page).to have_content("2.0")
    end
  end

  context "when setting has no group" do
    before do
      Sail::Setting.first.update!(group: nil)
      visit "/sail"
    end

    it "does not display group label" do
      within(all(".card").first) do
        expect(page).to have_no_css(".group-label", count: 1)
        expect(page).to have_no_content("feature_flags")
      end
    end
  end

  it "adjusts pagination if there are too many settings" do
    120.times do |index|
      Sail::Setting.create!(name: "new_setting_#{index}", cast_type: :string,
                            value: :something,
                            description: "Setting that does something",
                            group: "feature_flags")
    end

    visit "/sail"

    within("#pagination") do
      expect(page).to have_content("1 2 3 4 5 ●●● 8")
      click_link("8")
    end

    within("#pagination") do
      expect(page).to have_content("1 ●●● 3 4 5 6 7 8")
    end
  end

  it "shows description when clicking on title" do
    visit "/sail"

    setting = Sail::Setting.first
    first_card = all(".card").first

    expect_setting(setting)

    first_card.all("h3").first.click
    expect(first_card).to have_content(setting.description.capitalize)

    first_card.all("h3").last.click
    expect_setting(setting)
  end
end
