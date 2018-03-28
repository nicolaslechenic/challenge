require './lib/rental'

RSpec.describe Drivy::Rental do
  describe '.outputs' do
    it 'generate expected json file' do
      Drivy::Rental.output_json
      expected_file = File.read('output.expected.json')
      generated_file = File.read('output.json')

      expect(generated_file).to eq(expected_file)
    end
  end
end
