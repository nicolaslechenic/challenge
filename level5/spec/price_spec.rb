require './lib/price'

RSpec.describe Drivy::Price do
  let(:rental) do
    Drivy::Rental.all_from_json.first
  end

  describe '#total' do
    it 'return the expected total value' do
      price = described_class.new_from_rental(rental)

      expect(price.total).to eq(3000)
    end
  end
end
