require './lib/rental'

RSpec.describe Drivy::Rental do
  let(:rental) do
    described_class.all_from_json.first
  end

  it 'return rental' do
    expect(rental.id).to eq(1)
  end
end
