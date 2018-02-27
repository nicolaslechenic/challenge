require 'json'
require 'date'
require './lib/application'
require './lib/car'
require './lib/fee'
require './lib/rental'

DATAS_PATH = "#{Dir.pwd}/data.json".freeze

File.open('output.json', 'w') do |f|
  f.write(JSON.pretty_generate(rentals: Drivy::Rental.outputs))
end
