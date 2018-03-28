require 'json'
require 'date'
require './lib/action'
require './lib/car'
require './lib/rental'
require './lib/price'
require './lib/fee'

ROOT_PATH = Dir.pwd.freeze
DATA_PATH = "#{ROOT_PATH}/data.json".freeze
JSON_DATA = JSON.parse(File.read(DATA_PATH)).freeze

Drivy::Rental.output_json
