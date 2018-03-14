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
        next unless WHITELIST_CAR_ATTR.include?(key)
        instance_variable_set("@#{key}", value)
      end
    end

    def self.all
      json_datas['cars'].map { |car| new(car) }
    end

    # @return [Object] with specified car
    def self.find(car_id)
      car_found = all.find { |car| car.id == car_id }
      raise IndexError, format(ERRORS['car']['invalid_id'], car_id: car_id) if car_found.nil?

      car_found
    end
  end
end
