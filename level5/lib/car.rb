require 'pry'
module Drivy
  class Car < Application
    attr_accessor :id, :price_per_day, :price_per_km
    # List of attributes
    #
    #   * :id [Integer]
    #   * :price_per_day [Integer]
    #   * :price_per_km [Integer]
    def initialize(car_hash)
      car_hash.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # @return [Array<Object>] with all existing cars
    def self.all
      json_datas['cars'].map do |car|
        new(car)
      end
    end

    # @param [Integer] car id
    # @return [Object] with specified car
    def self.find(id)
      all.select { |car| car.id == id }[0]
    end
  end
end
