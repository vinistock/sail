describe Sail::ApplicationHelper, type: :helper do
  include Sail::ApplicationHelper

  describe '.number_of_pages' do
    subject { number_of_pages }

    before do
      (0...9).each { |i| Sail::Setting.create(name: "setting_#{i}", cast_type: :string, value: i) }
    end

    it 'returns number of pages' do
      expect(subject).to eq(2)
    end
  end
end
