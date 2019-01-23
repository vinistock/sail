# frozen_string_literal: true

feature "sorting settings", js: true, type: :feature do
  let!(:setting_1) do
    Sail::Setting.create!(name: "Bca",
                          cast_type: :integer,
                          value: "5",
                          description: "Setting that does something",
                          group: "tuners",
                          updated_at: 75.days.ago)
  end

  let!(:setting_2) do
    Sail::Setting.create!(name: "Abc",
                          cast_type: :string,
                          value: "A string",
                          description: "Setting that does something",
                          group: "general",
                          updated_at: 15.days.ago)
  end

  let!(:setting_3) do
    Sail::Setting.create!(name: "Acb",
                          cast_type: :boolean,
                          value: "true",
                          description: "Setting that does something",
                          group: "feature_flags",
                          updated_at: 30.days.ago)
  end

  let(:settings) { [setting_1, setting_2, setting_3] }

  before do
    visit "/sail"
    find("#btn-order").click

    within("#sort-menu") do
      click_on(sorting_field)
    end
  end

  [
    { field: "name", order: [0, 2, 1] },
    { field: "updated_at", order: [1, 2, 0] },
    { field: "cast_type", order: [2, 1, 0] },
    { field: "group", order: [0, 1, 2] }
  ].each do |info|
    context "when sorting field is #{info[:field]}" do
      let(:sorting_field) { info[:field] }

      it "orders settings by #{info[:field]}" do
        cards = all(".card")

        within(cards[0]) do
          expect_setting(settings[info[:order][0]])
        end

        within(cards[1]) do
          expect_setting(settings[info[:order][1]])
        end

        within(cards[2]) do
          expect_setting(settings[info[:order][2]])
        end
      end
    end
  end
end
