# frozen_string_literal: true

feature "viewing settings", js: true, type: :feature do
  before do
    5.times.with_index do |index|
      Sail::Setting.create!(name: "setting_#{index}", cast_type: :string,
                            value: :something,
                            description: "Setting that does something",
                            group: "feature_flags")
    end

    5.times.with_index do |index|
      Sail::Setting.create!(name: "setting_#{index + 5}", cast_type: :string,
                            value: :something,
                            description: "Setting that does something",
                            group: "tuners")
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
end
