# frozen_string_literal: true

feature "quick guide", js: true, type: :feature do
  before do
    visit "/sail"
  end

  it "displays reference on how to use the dashboard" do
    expect(page).to have_no_css("#guide-modal", visible: true)
    click_button("Guide")
    expect(page).to have_css("#guide-modal", visible: true)

    within("#guide-modal") do
      expect(page).to have_content("Searching")
      expect(page).to have_content("Profiles")
      expect(page).to have_content("Relevancy Score")
      expect(page).to have_content("Available groups and types")

      find("summary", text: "Searching").click
      expect(page).to have_content("By the setting name")
      find("summary", text: "Searching").click

      find("summary", text: "Profiles").click
      expect(page).to have_content("Profiles can be used")
      find("summary", text: "Profiles").click

      find("summary", text: "Relevancy Score").click
      expect(page).to have_content("Settings have a number on")
      find("summary", text: "Relevancy Score").click

      find("summary", text: "Available groups and types").click
      expect(page).to have_content("The cast types currently")
    end

    find("body").native.send_keys(:escape)
    expect(page).to have_no_css("#guide-modal", visible: true)
  end
end
