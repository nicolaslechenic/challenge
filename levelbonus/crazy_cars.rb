require 'rmagick'
require 'thor'
require './lib/cli'
require './lib/color'
require './lib/steps'

TOTAL_IMAGES = 3804
ORIGIN_IMAGES_URL = 'http://dontclickhere.drivy.com/img'.freeze
IMAGES_FOLDER = Dir.pwd + '/images'.freeze
ONES = %w[#3484C5 #363D85C0C65AFFFF].freeze
PINK = '#EE2E81'.freeze
WIDTH_SIZE = 20
HEIGHT_SIZE = 180

CrazyCars::CLI.start
