require './lib/rental'

RSpec.describe Drivy::Rental do
  let(:rental) do
    described_class.all_from_json.first
  end

  describe '#price' do
    it 'return expected price' do
      expect(rental.amount.total).to eq(3000)
    end
  end
end
