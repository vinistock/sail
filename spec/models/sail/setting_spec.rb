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
  end

  describe '.get' do
    subject { described_class.get(:setting) }

    before do
      Rails.cache.delete('setting_get_setting')
    end

    it 'caches response' do
      expect(Rails.cache).to receive(:fetch).with('setting_get_setting', expires_in: 10.minutes)
      subject
    end

    [
      { type: 'integer', value: '1', expected_value: 1 },
      { type: 'boolean', value: 'true', expected_value: true },
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
  end

  describe '.set' do
    before { Rails.cache.delete('setting_get_setting') }

    [
      { type: 'string', old: 'old_value', new: 'new_value', expected: 'new_value' },
      { type: 'boolean', old: 'false', new: 'true', expected: 'true' },
      { type: 'boolean', old: 'false', new: true, expected: 'true' }
    ].each do |test_data|
      context "when changing value of a #{test_data[:type]} setting" do
        let!(:setting) { described_class.create(name: :setting, value: test_data[:old], cast_type: described_class.cast_types[test_data[:type]]) }

        it 'sets value appropriately' do
          described_class.set(:setting, test_data[:new])
          expect(setting.reload.value).to eq(test_data[:expected])
        end

        it 'deletes cache' do
          expect(Rails.cache).to receive(:delete).with('setting_get_setting')
          described_class.set(:setting, test_data[:new])
        end
      end
    end
  end
end
