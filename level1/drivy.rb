require 'json'
require 'date'
require './lib/application'
require './lib/car'
require './lib/rental'

ROOT_PATH = Dir.pwd.freeze
DATA_PATH = "#{ROOT_PATH}/data.json".freeze

Drivy::Rental.output_json
