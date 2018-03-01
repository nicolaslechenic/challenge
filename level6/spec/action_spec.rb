require './lib/action'

RSpec.describe Drivy::Action do
  describe '.to_json' do
    context 'invalid amount' do
      it 'raise ArgumentError when amount is equal to zero' do
        expect { described_class.to_json('driver', 0) }.to output.to_stdout
      end
    end
  end
end
