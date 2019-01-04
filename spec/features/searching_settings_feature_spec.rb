# frozen_string_literal: true

feature "searching settings", js: true, type: :feature do
  let!(:setting_1) do
    Sail::Setting.create(name: :setting, cast_type: :string,
                         value: :something,
                         description: "Setting that does something",
                         group: "feature_flags")
  end

  let!(:setting_2) do
    Sail::Setting.create(name: :configuration, cast_type: :string,
                         value: :something,
                         description: "Setting that does something else",
                         group: "feature_flags")
  end

  before do
    visit "/sail"
    fill_in("query", with: query)
  end

  context "using submit via enter" do
    before { find("#query").native.send_keys(:return) }

    context "when name matches a setting" do
      let(:query) { setting_1.name }

      it "displays the found setting" do
        within(".card") do
          expect_setting(setting_1)
        end
      end
    end

    context "when searching by group" do
      let(:query) { "feature_flags" }

      it "displays all found settings for group" do
        expect_setting(setting_1)
        expect_setting(setting_2)
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

  context "using auto submit" do
    let(:query) { "feature_flags" }

    it "searches without clicking enter" do
      sleep 3
      expect_setting(setting_1)
      expect_setting(setting_2)
    end
  end
end
