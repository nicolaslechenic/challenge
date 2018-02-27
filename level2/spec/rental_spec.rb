require './lib/rental'

RSpec.describe Drivy::Rental do
  describe '.prices' do
    subject { described_class.prices }

    it 'return rentals prices with reduction for long period' do
      expect(subject).to eq([3000, 6800, 27_800])
    end
  end
end
