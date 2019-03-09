# frozen_string_literal: true

feature "quick guide", js: true, type: :feature do
  before do
    visit "/sail"
  end

  it "displays reference on how to use the dashboard" do
    expect(page).to have_no_css("#guide-modal", visible: true)
    click_button("Guide")
    expect(page).to have_css("#guide-modal", visible: true)
  end
end
