require './lib/fee'

RSpec.describe Drivy::Fee do
  describe '#total' do
    it 'return 30% of amount' do
      fee = described_class.new(100, 10)

      expect(fee.total).to eq(30)
    end
  end
end
