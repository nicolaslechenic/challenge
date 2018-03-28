require './lib/car'

RSpec.describe Drivy::Car do
  describe '.find_from_json' do
    context 'valid id' do
      subject { described_class.find_from_json(1) }

      it 'return car datas for specified id' do
        expect(subject.price_per_day).to eq(2000)
        expect(subject.price_per_km).to eq(10)
      end
    end

    context 'invalid id' do
      subject { described_class.find_from_json(2) }

      it 'return error when car id is invalid' do
        expect { subject }.to raise_error(IndexError)
      end
    end
  end
end
