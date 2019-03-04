# frozen_string_literal: true

feature "relevancy score", type: :feature, js: true do
  let!(:setting_1) { Sail::Setting.create!(name: :setting_1, cast_type: :integer, value: 1) }
  let!(:setting_2) { Sail::Setting.create!(name: :setting_2, cast_type: :integer, value: 2) }

  it "updates as settings are used" do
    force_cache_expire
    visit "/sail"

    cards = all(".card")

    within(cards[0]) do
      expect(page).to have_content("0.0")
    end

    within(cards[1]) do
      expect(page).to have_content("0.0")
    end

    Sail.get(:setting_1)
    3.times { Sail.get(:setting_2) }
    force_cache_expire

    visit "/sail"

    cards = all(".card")

    within(cards[0]) do
      expect(page).to have_content("12.5")
    end

    within(cards[1]) do
      expect(page).to have_content("37.5")
    end
  end

  private

  def force_cache_expire
    Sail.set(:setting_1, 10 * rand.round(0))
  end
end
