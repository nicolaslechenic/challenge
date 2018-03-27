require './lib/rental'

RSpec.describe Drivy::Rental do
  let(:rental) do
    described_class.all_from_json.first
  end

  describe '#price' do
    it 'return expected price' do
      expect(rental.price).to eq(7000)
    end
  end
end
