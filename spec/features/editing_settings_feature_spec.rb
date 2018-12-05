# frozen_string_literal: true

feature "editing settings", js: true, type: :feature do
  [
      { type: "float", old: "1.532", new: "1.324" },
      { type: "integer", old: "15", new: "8" },
      { type: "array", old: "John;Ted", new: "John;Ted;Mark" },
      { type: "string", old: "old_value", new: "new_value" },
      { type: "ab_test", old: "true", new: "false" },
      { type: "cron", old: "* * * * *", new: "*/5 * 10 * *" },
      { type: "obj_model", old: "Test2", new: "Test" },
      { type: "uri", old: "https://youtube.com", new: "https://google.com" },
      { type: "boolean", old: "false", new: "true" },
      { type: "date", old: "2010-01-30", new: DateTime.parse("2018-01-30") }
  ].each do |set|
    context "when setting is of type #{set[:type]}" do
      let!(:setting) { Sail::Setting.create(name: :setting, cast_type: set[:type], value: set[:old]) }

      before do
        visit "/sail"
      end

      it "properly changes the setting's value" do
        within(".card") do
          send("fill_for_#{set[:type]}", set[:new])
          click_button("SAVE")
        end

        within(".notice") do
          expect(page).to have_content("Updated!")
        end

        if set[:type] == "date"
          expect(setting.reload.value).to eq("2018-01-30T00:00")
        else
          expect(setting.reload.value).to eq(set[:new])
        end
      end
    end
  end

  private

  def fill_for_float(value)
    fill_in("value", with: value)
  end

  def fill_for_integer(value)
    fill_in("value", with: value)
  end

  def fill_for_array(value)
    fill_in("value", with: value)
  end

  def fill_for_string(value)
    fill_in("value", with: value)
  end

  def fill_for_ab_test(value)
    find("label.switch").click
  end

  def fill_for_cron(value)
    fill_in("value", with: value)
  end

  def fill_for_obj_model(value)
    fill_in("value", with: value)
  end

  def fill_for_uri(value)
    fill_in("value", with: value)
  end

  def fill_for_boolean(value)
    find("label.switch").click
  end

  def fill_for_date(value)
    fill_in("value", with: value)
  end
end
