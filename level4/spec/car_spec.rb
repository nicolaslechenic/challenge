require './lib/car'

RSpec.describe Drivy::Car do
  describe '.find' do
    subject { described_class.find(1) }

    it 'return car datas for specified id' do
      expect(subject.price_per_day).to eq(2000)
      expect(subject.price_per_km).to eq(10)
    end
  end
end
