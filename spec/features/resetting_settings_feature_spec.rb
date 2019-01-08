# frozen_string_literal: true

feature "resetting settings", js: true, type: :feature do
  let!(:setting) do
    allow(Sail::Setting).to receive(:config_file_path).and_return("#{Rails.root}/config/sail.yml")

    Sail::Setting.create!(name: name, cast_type: cast_type,
                          value: setting_value,
                          description: "Setting that does something",
                          group: "feature_flags")
  end

  before do
    visit "/sail"
    within(".card") { find(".refresh-button").click }
  end

  context "for a non boolean setting" do
    let(:cast_type) { :integer }
    let(:setting_value) { "321" }
    let(:name) { "number_of_threads" }

    it "resets value and refreshes input" do
      expect(page).to have_content("Updated!")

      within(".card") do
        expect(find("#input_for_#{setting.name}", visible: false)[:value]).to eq("123")
      end

      expect(setting.reload.value).to eq("123")
    end
  end

  context "for a boolean setting" do
    let(:cast_type) { :boolean }
    let(:setting_value) { "false" }
    let(:name) { "enable_something" }

    it "resets value and refreshes input" do
      expect(page).to have_content("Updated!")
      expect(setting.reload.value).to eq("true")
    end
  end
end
