module Drivy
  class Car
    class << self
      # @return [Array<Object>] with all existing cars
      def all_from_json
        JSON_DATA['cars'].map do |car|
          new(car['id'], car['price_per_day'], car['price_per_km'])
        end
      end

      # @param [Integer] car id
      # @return [Object] with specified car
      def find(id)
        all_from_json.find { |car| car.id == id }
      end
    end

    attr_accessor :id, :price_per_day, :price_per_km

    def initialize(id, price_per_day, price_per_km)
      @id = id
      @price_per_day = price_per_day
      @price_per_km = price_per_km
    end
  end
end
