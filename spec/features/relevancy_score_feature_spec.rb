# frozen_string_literal: true

feature "relevancy score", js: true, type: :feature do
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
    Sail.instrumenter.instance_variable_set(:@statistics, {}.with_indifferent_access)
    visit "/sail"
  end

  it "displays relevancy score in each setting" do
    cards = all(".relevancy-score")

    expect(cards[0]).to have_content("0.0")
    expect(cards[1]).to have_content("0.0")

    500.times { Sail.get(:setting) }
    1000.times { Sail.get(:configuration) }

    click_link("Sail")

    cards = all(".relevancy-score")

    expect(cards[0]).to have_content("16.7")
    expect(cards[1]).to have_content("33.3")
  end
end
