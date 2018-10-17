describe Sail::Setting, type: :model do
  describe 'validations' do
    describe 'value_is_within_range' do
      context 'when cast type is not range' do
        subject { described_class.new(name: :setting, value: 150, cast_type: :integer) }
        it { is_expected.to be_valid }
      end

      context 'when cast type is range' do
        context 'and value is inside range' do
          subject { described_class.new(name: :setting, value: 99, cast_type: :range) }
          it { is_expected.to be_valid }
        end

        context 'and value is outside range' do
          subject { described_class.new(name: :setting, value: 150, cast_type: :range) }
          it { is_expected.to be_invalid }
        end
      end
    end

    describe 'value_is_a_valid_date' do
      context 'when cast type a valid date' do
        subject { described_class.new(name: :setting, value: '2010-01-31', cast_type: :date) }
        it { is_expected.to be_valid }
      end

      context 'when cast type is not a valid date' do
        subject { described_class.new(name: :setting, value: 'April 15, 2018', cast_type: :date) }
        it { is_expected.to be_invalid }
      end
    end

    describe 'value_is_true_or_false' do
      context 'when type is not boolean' do
        subject { described_class.new(name: :setting, value: 'not a boolean', cast_type: :string) }
        it { is_expected.to be_valid }
      end

      context 'when type is boolean and value is false' do
        subject { described_class.new(name: :setting, value: 'false', cast_type: :boolean) }
        it { is_expected.to be_valid }
      end

      context 'when type is boolean and value is true' do
        subject { described_class.new(name: :setting, value: 'true', cast_type: :boolean) }
        it { is_expected.to be_valid }
      end

      context 'when type is boolean and value is whatever' do
        subject { described_class.new(name: :setting, value: 'whatever', cast_type: :boolean) }
        it { is_expected.to be_invalid }
      end

      context 'when type is ab_test and value is false' do
        subject { described_class.new(name: :setting, value: 'false', cast_type: :ab_test) }
        it { is_expected.to be_valid }
      end

      context 'when type is ab_test and value is true' do
        subject { described_class.new(name: :setting, value: 'true', cast_type: :ab_test) }
        it { is_expected.to be_valid }
      end

      context 'when type is ab_test and value is whatever' do
        subject { described_class.new(name: :setting, value: 'whatever', cast_type: :ab_test) }
        it { is_expected.to be_invalid }
      end
    end

    describe 'cron_is_valid' do
      context 'when type is cron and value is a proper cron string' do
        subject { described_class.new(name: :setting, value: '3 * 5 * *', cast_type: :cron) }
        it { is_expected.to be_valid }
      end

      context 'when type is cron and value is not a proper cron string' do
        subject { described_class.new(name: :setting, value: 'whatever', cast_type: :cron) }
        it { is_expected.to be_invalid }
      end
    end

    describe 'model_exists' do
      context 'when model exists' do
        subject { described_class.new(name: :setting, value: 'Test', cast_type: :obj_model) }
        it { is_expected.to be_valid }
      end

      context 'when model does not exist' do
        subject { described_class.new(name: :setting, value: 'Invalid', cast_type: :obj_model) }
        it { is_expected.to be_invalid }
      end
    end
  end

  describe 'scopes' do
    describe '.paginated' do
      let!(:settings) { (0...40).map { |i| described_class.create(name: "setting_#{i}", cast_type: :integer, value: '0') } }

      it 'paginates results' do
        expect(described_class.paginated(0).map(&:name)).to eq(settings[0...8].map(&:name))
        expect(described_class.paginated(1).map(&:name)).to eq(settings[8...16].map(&:name))
      end
    end

    describe '.by_query' do
      subject { described_class.by_name(query) }
      let!(:setting) { described_class.create(name: 'My Setting', cast_type: :integer, value: '0') }

      context 'when name matches partially' do
        let(:query) { 'y Sett' }
        it { expect(subject).to include(setting) }
      end

      context 'when name matches fully' do
        let(:query) { 'My Setting' }
        it { expect(subject).to include(setting) }
      end

      context 'when name does not match' do
        let(:query) { 'whatever' }
        it { expect(subject).to_not include(setting) }
      end

      context 'when query is empty' do
        let(:query) { '' }
        it { expect(subject).to include(setting) }
      end
    end
  end

  describe '.get' do
    subject { described_class.get(:setting) }

    before do
      Rails.cache.delete('setting_get_setting')
      allow(DateTime).to receive(:now).and_return(DateTime.parse('2018-10-05 20:00'))
    end

    it 'caches response' do
      expect(Rails.cache).to receive(:fetch).with('setting_get_setting', expires_in: Sail.configuration.cache_life_span)
      subject
    end

    [
      { type: 'integer', value: '1', expected_value: 1 },
      { type: 'float', value: '1.123', expected_value: 1.123 },
      { type: 'date', value: '2015-04-15', expected_value: '2015-04-15' },
      { type: 'date', value: '15 April 2018', expected_value: nil },
      { type: 'boolean', value: 'true', expected_value: true },
      { type: 'ab_test', value: 'false', expected_value: false },
      { type: 'cron', value: '* * 5 * *', expected_value: true },
      { type: 'cron', value: '* * 6 * *', expected_value: false },
      { type: 'obj_model', value: 'Test', expected_value: Test },
      { type: 'range', value: '1', expected_value: 1 },
      { type: 'array', value: '1;2;3;4', expected_value: %w[1 2 3 4] },
      { type: 'string', value: '1', expected_value: '1' }
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

    context 'when looking for a setting that does not exist' do
      subject { described_class.get(:whatever) }
      it { is_expected.to be_nil }
    end
  end

  describe '.set' do
    before { Rails.cache.delete('setting_get_setting') }

    [
      { type: 'float', old: '1.532', new: 1.324, expected: '1.324' },
      { type: 'integer', old: '15', new: 8, expected: '8' },
      { type: 'array', old: 'John;Ted', new: %w[John Ted Mark], expected: 'John;Ted;Mark' },
      { type: 'string', old: 'old_value', new: 'new_value', expected: 'new_value' },
      { type: 'ab_test', old: 'true', new: 'false', expected: 'false' },
      { type: 'ab_test', old: 'true', new: false, expected: 'false' },
      { type: 'ab_test', old: 'false', new: 'on', expected: 'true' },
      { type: 'cron', old: '* * * * *', new: '*/5 * 10 * *', expected: '*/5 * 10 * *' },
      { type: 'obj_model', old: 'Test2', new: 'Test', expected: 'Test' },
      { type: 'boolean', old: 'false', new: 'true', expected: 'true' },
      { type: 'boolean', old: 'false', new: 'on', expected: 'true' },
      { type: 'boolean', old: 'false', new: true, expected: 'true' },
      { type: 'date', old: '2010-01-30', new: '2018-01-30', expected: '2018-01-30' }
    ].each do |test_data|
      context "when changing value of a #{test_data[:type]} setting" do
        let!(:setting) { described_class.create!(name: :setting, value: test_data[:old], cast_type: described_class.cast_types[test_data[:type]]) }

        it 'sets value appropriately' do
          described_class.set(:setting, test_data[:new])
          expect(setting.reload.value).to eq(test_data[:expected])
        end

        it 'deletes cache' do
          expect(Rails.cache).to receive(:delete).with('setting_get_setting')
          described_class.set(:setting, test_data[:new])
        end

        it 'returns setting and success flag' do
          setting, flag = described_class.set(:setting, test_data[:new])
          expect(setting).to be_a(Sail::Setting)
          expect(flag).to eq(true)
        end
      end
    end
  end

  describe '#display_name' do
    subject { Sail::Setting.create(name: 'my#setting_with+symbols', cast_type: :string, value: 'whatever').display_name }
    it { expect(subject).to eq('My Setting With Symbols') }
  end
end
