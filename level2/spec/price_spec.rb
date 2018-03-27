require './lib/price'

RSpec.describe Drivy::Price do
  let(:rental) do
    Drivy::Rental.all_from_json.first
  end

  describe '.total_for_rental' do
    it 'return expected total price for specified rental' do
      price = described_class.total_for_rental(rental)

      expect(price).to eq(3000)
    end
  end
end
