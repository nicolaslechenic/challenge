require 'json'
require 'date'
require 'pry'
require './lib/core_ext'
require './lib/application'
require './lib/action'
require './lib/fee'
require './lib/car'
require './lib/rental'

DATAS_PATH = "#{Dir.pwd}/data.json".freeze

File.open('output.json', 'w') do |f|
  f.write(JSON.pretty_generate(rental_modifications: Drivy::Rental.output_modifications))
end
