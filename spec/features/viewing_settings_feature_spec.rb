# frozen_string_literal: true

feature "viewing settings", js: true, type: :feature do
  before do
    10.times.with_index do |index|
      Sail::Setting.create!(name: "setting_#{index}", cast_type: :string,
                            value: :something,
                            description: "Setting that does something")
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
end
