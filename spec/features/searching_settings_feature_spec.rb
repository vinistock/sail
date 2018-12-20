# frozen_string_literal: true

feature "searching settings", js: true, type: :feature do
  let!(:setting) { Sail::Setting.create(name: :setting, cast_type: :string,
                                              value: :something,
                                              description: "Setting that does something",
                                              group: "feature_flags") }

  before do
    visit "/sail"
    fill_in("query", with: query)
    find("#query").native.send_keys(:return)
  end

  context "when name matches a setting" do
    let(:query) { setting.name }

    it "displays the found setting" do
      within(".card") do
        expect_setting(setting)
      end
    end
  end

  context "when name does not match any setting" do
    let(:query) { "whatever" }

    it "displays no settings found" do
      within("#settings-container") do
        expect(page).to have_text("No settings found")
      end
    end
  end
end
