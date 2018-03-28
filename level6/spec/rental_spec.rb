require './lib/rental'

RSpec.describe Drivy::Rental do
  let(:rental) do 
    described_class.new(
      'id' => 1,
      'car_id' => 1,
      'start_date' => '2015-12-8',
      'end_date' => '2015-12-8',
      'distance' => 100,
      'deductible_reduction' => true
    )
  end

  context 'invalid end date' do 
    it 'return RangeError exception' do
      rental.end_date = rental.start_date - 1

      expect { rental.duration }.to raise_error(RangeError)
    end
  end

  context 'invalid id' do
    subject { described_class.find_from_json(4) }

    it 'return error when car id is invalid' do
      expect { subject }.to raise_error(IndexError)
    end
  end

  describe '.output_json' do
    it 'generate expected json file' do
      described_class.output_json

      expected_file = File.read('output.expected.json')
      generated_file = File.read('output.json')

      expect(generated_file).to eq(expected_file)
    end
  end
end
