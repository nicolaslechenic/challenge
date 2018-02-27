require 'json'
require 'date'
require './lib/application'
require './lib/car'
require './lib/rental'

DATAS_PATH = "#{Dir.pwd}/data.json".freeze

rental_prices = Drivy::Rental.prices.map.with_index do |price, index|
  {
    id: index + 1,
    price: price
  }
end

File.open('output.json', 'w') do |f|
  f.write(JSON.pretty_generate(rentals: rental_prices))
end
