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

    visit "/sail"
  end

  it "displays setting information and allows navigation" do
    Sail::Setting.first(8).each { |setting| expect_setting(setting) }

    within("#pagination") do
      click_link("2")
    end

    Sail::Setting.last(2).each { |setting| expect_setting(setting) }
  end

  it "allows clicking on groups to filter" do
    within(all(".card").first) do
      click_link("feature_flags")
    end

    expect(page).to have_css(".card", count: 5)
  end

  it "allows clicking on types to filter" do
    within(all(".card").first) do
      click_link("string")
    end

    expect(page).to have_css(".card", count: 5)
  end

  it "allows clicking on stale to filter" do
    within(all(".card").last) do
      click_link("stale")
    end

    expect(page).to have_css(".card", count: 5)
  end

  it "has a main app link" do
    expect(page).to have_link("Main app")
    click_link("Main app")
    expect(page).to have_text("Inside dummy app")
  end
end
