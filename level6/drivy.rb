require 'colorize'
require 'date'
require 'json'
require 'pry'
require 'yaml'
require './lib/application'
require './lib/action'
require './lib/fee'
require './lib/car'
require './lib/rental'

DATAS_PATH = "#{Dir.pwd}/data.json".freeze
ERRORS = YAML.load_file('locales.yml')['errors']
WHITELIST_CAR_ATTR = %w[id price_per_day price_per_km].freeze
WHITELIST_RENTAL_ATTR =
  %w[id car_id start_date end_date distance deductible_reduction].freeze
FEES_ON_PRICE_PER_ONE = 0.3
OPTION_PRICE_PER_DAY = 400
ASSISTANCE_FEE_PER_DAY = 100

File.open('output.json', 'w') do |f|
  f.write(JSON.pretty_generate(rental_modifications: Drivy::Rental.output_modifications))
end
