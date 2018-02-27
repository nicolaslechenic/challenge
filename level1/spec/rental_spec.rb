require './lib/rental'

RSpec.describe Drivy::Rental do
  describe '.prices' do
    subject { described_class.prices }

    it 'return all rental prices' do
      expect(subject).to eq([7000, 15_500, 11_250])
    end
  end
end
