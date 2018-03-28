require './lib/fee'

RSpec.describe Drivy::Fee do
  describe '#total' do
    it '...' do
      fee = described_class.new(100, 10)

      expect(fee.total).to eq(30)
    end
  end
end
