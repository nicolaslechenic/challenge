module Drivy
  class Car
    class << self
      # @return [Array<Object>] with all existing cars
      def all_from_json
        JSON_DATA['cars'].map do |car|
          new(
            id: car['id'],
            price_per_day: car['price_per_day'],
            price_per_km: car['price_per_km']
          )
        end
      end

      # @param [Integer] car id
      # @return [Object] with specified car
      def find(id)
        all_from_json.find { |car| car.id == id }
      end
    end

    AUTHORIZED = %i[id price_per_day price_per_km].freeze

    attr_accessor *AUTHORIZED

    def initialize(car_hash)
      car_hash.each do |key, value|
        next unless AUTHORIZED.include?(key)
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
