require './lib/rental'

RSpec.describe Drivy::Rental do
  describe '.outputs' do
    subject { described_class.output_modifications }

    it 'generate expected json file' do
      expected_file = File.read('output.expected.json')
      generated_file = JSON.pretty_generate(rental_modifications: subject)

      expect(generated_file).to eq(expected_file)
    end
  end
end
