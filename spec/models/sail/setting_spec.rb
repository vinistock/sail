# frozen_string_literal: true

describe Sail::Setting, type: :model do
  describe "validations" do
    describe "value_is_within_range" do
      context "when cast type is not range" do
        subject { described_class.new(name: :setting, value: 150, cast_type: :integer) }
        it { is_expected.to be_valid }
      end

      context "when cast type is range" do
        context "and value is inside range" do
          subject { described_class.new(name: :setting, value: 99, cast_type: :range) }
          it { is_expected.to be_valid }
        end

        context "and value is outside range" do
          subject { described_class.new(name: :setting, value: 150, cast_type: :range) }
          it { is_expected.to be_invalid }
        end
      end
    end

    describe "value_is_a_valid_date" do
      context "when cast type a valid date in numbers" do
        subject { described_class.new(name: :setting, value: "2010-01-31", cast_type: :date) }
        it { is_expected.to be_valid }
      end

      context "when cast type is a valid date in words" do
        subject { described_class.new(name: :setting, value: "April 15, 2018", cast_type: :date) }
        it { is_expected.to be_valid }
      end

      context "when cast type is not a valid date" do
        subject { described_class.new(name: :setting, value: "random date value", cast_type: :date) }
        it { is_expected.to be_invalid }
      end
    end

    describe "value_is_true_or_false" do
      context "when type is not boolean" do
        subject { described_class.new(name: :setting, value: "not a boolean", cast_type: :string) }
        it { is_expected.to be_valid }
      end

      context "when type is boolean and value is false" do
        subject { described_class.new(name: :setting, value: "false", cast_type: :boolean) }
        it { is_expected.to be_valid }
      end

      context "when type is boolean and value is true" do
        subject { described_class.new(name: :setting, value: "true", cast_type: :boolean) }
        it { is_expected.to be_valid }
      end

      context "when type is boolean and value is whatever" do
        subject { described_class.new(name: :setting, value: "whatever", cast_type: :boolean) }
        it { is_expected.to be_invalid }
      end

      context "when type is ab_test and value is false" do
        subject { described_class.new(name: :setting, value: "false", cast_type: :ab_test) }
        it { is_expected.to be_valid }
      end

      context "when type is ab_test and value is true" do
        subject { described_class.new(name: :setting, value: "true", cast_type: :ab_test) }
        it { is_expected.to be_valid }
      end

      context "when type is ab_test and value is whatever" do
        subject { described_class.new(name: :setting, value: "whatever", cast_type: :ab_test) }
        it { is_expected.to be_invalid }
      end
    end

    describe "cron_is_valid" do
      context "when type is cron and value is a proper cron string" do
        subject { described_class.new(name: :setting, value: "3 * 5 * *", cast_type: :cron) }
        it { is_expected.to be_valid }
      end

      context "when type is cron and value is not a proper cron string" do
        subject { described_class.new(name: :setting, value: "whatever", cast_type: :cron) }
        it { is_expected.to be_invalid }
      end
    end

    describe "model_exists" do
      context "when model exists" do
        subject { described_class.new(name: :setting, value: "Test", cast_type: :obj_model) }
        it { is_expected.to be_valid }
      end

      context "when model does not exist" do
        subject { described_class.new(name: :setting, value: "Invalid", cast_type: :obj_model) }
        it { is_expected.to be_invalid }
      end
    end

    describe "url_is_valid" do
      context "when format is valid" do
        subject { described_class.new(name: :setting, value: "https://google.com", cast_type: :uri) }
        it { is_expected.to be_valid }
      end

      context "when format is invalid" do
        subject { described_class.new(name: :setting, value: "whatever string", cast_type: :uri) }
        it { is_expected.to be_invalid }
      end
    end
  end

  describe "scopes" do
    describe ".paginated" do
      let!(:settings) { (0...40).map { |i| described_class.create(name: "setting_#{i}", cast_type: :integer, value: "0") } }

      it "paginates results" do
        expect(described_class.paginated(0).map(&:name)).to eq(settings[0...8].map(&:name))
        expect(described_class.paginated(1).map(&:name)).to eq(settings[8...16].map(&:name))
      end
    end

    describe ".by_name" do
      subject { described_class.by_name(query) }
      let!(:setting) { described_class.create(name: "My Setting", cast_type: :integer, value: "0") }

      context "when name matches partially" do
        let(:query) { "y Sett" }
        it { expect(subject).to include(setting) }
      end

      context "when name matches fully" do
        let(:query) { "My Setting" }
        it { expect(subject).to include(setting) }
      end

      context "when name does not match" do
        let(:query) { "whatever" }
        it { expect(subject).to_not include(setting) }
      end

      context "when query is empty" do
        let(:query) { "" }
        it { expect(subject).to include(setting) }
      end
    end

    describe ".by_group" do
      subject { described_class.by_group(group) }
      let!(:setting) { described_class.create(name: "My Setting", cast_type: :boolean, value: "false", group: "feature_flags") }

      context "when passing the correct group" do
        let(:group) { "feature_flags" }
        it { expect(subject).to include(setting) }
      end

      context "when not passing correct group" do
        let(:group) { "whatever" }
        it { expect(subject).to_not include(setting) }
      end
    end

    describe ".by_query" do
      subject { described_class.by_query(query) }
      let!(:setting_1) { described_class.create(name: "My Setting", cast_type: :boolean, value: "false", group: "feature_flags") }
      let!(:setting_2) { described_class.create(name: "Your Setting", cast_type: :string, value: "something", group: "tuners") }

      context "when query is a group" do
        let(:query) { "feature_flags" }

        it "searches by group and not by name" do
          expect(subject).to include(setting_1)
          expect(subject).to_not include(setting_2)
        end
      end

      context "when query is a name" do
        let(:query) { "Your" }

        it "searches by group and not by name" do
          expect(subject).to_not include(setting_1)
          expect(subject).to include(setting_2)
        end
      end

      context "when query is a type" do
        let(:query) { "string" }

        it "searches by group and not by name" do
          expect(subject).to_not include(setting_1)
          expect(subject).to include(setting_2)
        end
      end
    end
  end

  describe ".get" do
    subject { described_class.get(:setting) }

    before do
      Rails.cache.delete("setting_get_setting")
      allow(DateTime).to receive(:now).and_return(DateTime.parse("2018-10-05 20:00"))
    end

    it "caches response" do
      expect(Rails.cache).to receive(:fetch).with("setting_get_setting", expires_in: Sail.configuration.cache_life_span)
      subject
    end

    [
      { type: "integer", value: "1", expected_value: 1 },
      { type: "float", value: "1.123", expected_value: 1.123 },
      { type: "date", value: "2015-04-15", expected_value: "2015-04-15" },
      { type: "date", value: "15 April, 2018", expected_value: "April 15, 2018" },
      { type: "date", value: "April, 15 2018", expected_value: "15th April 2018" },
      { type: "date", value: "15-Apr-2018", expected_value: "15-Apr-2018" },
      { type: "boolean", value: "true", expected_value: true },
      { type: "ab_test", value: "false", expected_value: false },
      { type: "cron", value: "* * 5 * *", expected_value: true },
      { type: "cron", value: "* * 6 * *", expected_value: false },
      { type: "obj_model", value: "Test", expected_value: Test },
      { type: "uri", value: "https://google.com", expected_value: URI("https://google.com") },
      { type: "range", value: "1", expected_value: 1 },
      { type: "array", value: "1;2;3;4", expected_value: %w[1 2 3 4] },
      { type: "throttle", value: 100.0, expected_value: true },
      { type: "throttle", value: 0.0, expected_value: false },
      { type: "string", value: "1", expected_value: "1" }
    ].each do |test_data|
      context "when setting type is #{test_data[:type]}" do
        before do
          described_class.create(name: :setting,
                                 value: test_data[:value],
                                 cast_type: described_class.cast_types[test_data[:type]])
        end

        it { is_expected.to eq(test_data[:expected_value]) }
      end
    end

    context "when looking for a setting that does not exist" do
      subject { described_class.get(:whatever) }
      it { is_expected.to be_nil }
    end
  end

  describe ".set" do
    before { Rails.cache.delete("setting_get_setting") }

    [
      { type: "float", old: "1.532", new: 1.324, expected: "1.324" },
      { type: "integer", old: "15", new: 8, expected: "8" },
      { type: "array", old: "John;Ted", new: %w[John Ted Mark], expected: "John;Ted;Mark" },
      { type: "string", old: "old_value", new: "new_value", expected: "new_value" },
      { type: "ab_test", old: "true", new: "false", expected: "false" },
      { type: "ab_test", old: "true", new: false, expected: "false" },
      { type: "ab_test", old: "false", new: "on", expected: "true" },
      { type: "cron", old: "* * * * *", new: "*/5 * 10 * *", expected: "*/5 * 10 * *" },
      { type: "obj_model", old: "Test2", new: "Test", expected: "Test" },
      { type: "uri", old: "https://youtube.com", new: "https://google.com", expected: "https://google.com" },
      { type: "boolean", old: "false", new: "true", expected: "true" },
      { type: "boolean", old: "false", new: "on", expected: "true" },
      { type: "boolean", old: "false", new: true, expected: "true" },
      { type: "throttle", old: "30.5", new: 45.0, expected: "45.0" },
      { type: "date", old: "2010-01-30", new: "2018-01-30", expected: "2018-01-30" }
    ].each do |test_data|
      context "when changing value of a #{test_data[:type]} setting" do
        let!(:setting) do
          described_class.create!(name: :setting,
                                  value: test_data[:old],
                                  cast_type: described_class.cast_types[test_data[:type]])
        end

        it "sets value appropriately" do
          described_class.set(:setting, test_data[:new])
          expect(setting.reload.value).to eq(test_data[:expected])
        end

        it "deletes cache" do
          expect(Rails.cache).to receive(:delete).with("setting_get_setting")
          described_class.set(:setting, test_data[:new])
        end

        it "returns setting and success flag" do
          setting, flag = described_class.set(:setting, test_data[:new])
          expect(setting).to be_a(Sail::Setting)
          expect(flag).to eq(true)
        end
      end
    end
  end

  describe ".switcher" do
    subject { described_class.switcher(positive: :positive, negative: :negative, throttled_by: :throttle) }
    let!(:throttle_setting) { described_class.create!(name: :throttle, cast_type: :throttle, value: "50.0") }

    before do
      Rails.cache.delete("setting_get_positive")
      Rails.cache.delete("setting_get_negative")
      Rails.cache.delete("setting_get_throttle")
      described_class.create!(name: :positive, cast_type: :string, value: "I'm the primary!")
      described_class.create!(name: :negative, cast_type: :integer, value: "7")
      allow(described_class).to receive(:rand).and_return(random_value)
    end

    context "when random value is smaller than throttle" do
      let(:random_value) { 0.25 }
      it { is_expected.to eq("I'm the primary!") }
    end

    context "when random value is greater than throttle" do
      let(:random_value) { 0.75 }
      it { is_expected.to eq(7) }
    end

    context "when throttle setting is of the wrong type" do
      let!(:throttle_setting) { described_class.create!(name: :throttle, cast_type: :boolean, value: "true") }
      let(:random_value) { 0.75 }
      it { expect { subject }.to raise_error(Sail::Setting::UnexpectedCastType) }
    end

    context "when throttle setting does not exist" do
      let!(:throttle_setting) { described_class.create!(name: :wrong_name, cast_type: :boolean, value: "true") }
      let(:random_value) { 0.75 }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "#display_name" do
    subject { Sail::Setting.create(name: "my#setting_with+symbols", cast_type: :string, value: "whatever").display_name }
    it { expect(subject).to eq("My Setting With Symbols") }
  end

  describe ".reset" do
    subject { described_class.reset("setting") }
    let!(:setting) { described_class.create!(name: :setting, cast_type: :string, value: "first string") }
    let(:file_contents) { { "setting" => { "value" => "second string" } } }

    before do
      allow(File).to receive(:exist?).with("#{Rails.root}/config/sail.yml").and_return(file_exists)
      allow(YAML).to receive(:load_file).with("#{Rails.root}/config/sail.yml").and_return(file_contents)
    end

    context "when file exists" do
      let(:file_exists) { true }

      it "resets value based on config file" do
        expect(Sail::Setting).to receive(:set).with("setting", "second string").and_call_original
        expect(Rails.cache).to receive(:delete).with("setting_get_setting")
        subject
        expect(setting.reload.value).to eq("second string")
      end
    end

    context "when file doesn't exist" do
      let(:file_exists) { false }

      it "does nothing" do
        expect(Sail::Setting).to_not receive(:set).with("setting", "second string").and_call_original
        expect(Rails.cache).to_not receive(:delete).with("setting_get_setting")
        subject
        expect(setting.reload.value).to eq("first string")
      end
    end
  end
end
