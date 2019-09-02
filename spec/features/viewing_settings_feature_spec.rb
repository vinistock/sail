# frozen_string_literal: true

feature "viewing settings", js: true, type: :feature do
  before do
    5.times do |index|
      Sail::Setting.create!(name: "setting_#{index}", cast_type: :string,
                            value: :something,
                            description: "Setting that does something",
                            group: "feature_flags")
    end

    5.times do |index|
      Sail::Setting.create!(name: "setting_#{index + 5}", cast_type: :integer,
                            value: "5",
                            description: "Setting that does something",
                            group: "tuners",
                            updated_at: 75.days.ago)
    end
  end

  it "displays setting information and allows navigation" do
    visit "/sail"

    Sail::Setting.first(8).each { |setting| expect_setting(setting) }

    within("#pagination") do
      click_link("2")
    end

    Sail::Setting.last(2).each { |setting| expect_setting(setting) }

    find("#angle-left-link").click
    Sail::Setting.first(8).each { |setting| expect_setting(setting) }

    find("#angle-right-link").click
    Sail::Setting.last(2).each { |setting| expect_setting(setting) }
  end

  it "allows clicking on groups to filter" do
    visit "/sail"

    within(all(".card").first) do
      click_link("feature_flags")
    end

    expect(page).to have_css(".card", count: 5)
  end

  it "allows clicking on types to filter" do
    visit "/sail"

    within(all(".card").first) do
      click_link("string")
    end

    expect(page).to have_css(".card", count: 5)
  end

  it "allows clicking on stale to filter" do
    visit "/sail"

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
    Sail.instrumenter.instance_variable_set(:@statistics, { settings: {} }.with_indifferent_access)
    2.times { Sail.get("setting_0") }
    2.times { Sail.get("setting_1") }

    visit "/sail"

    within(all(".card").first) do
      expect(find("h3")).to have_content("5.0")
    end
  end

  context "when setting has no group" do
    before do
      Sail::Setting.first.update!(group: nil)
      visit "/sail"
    end

    it "does not display group label" do
      within(all(".card").first) do
        expect(page).to have_css(".label-container", count: 1)
        expect(page).to have_no_content("feature_flags")
      end
    end
  end
end
