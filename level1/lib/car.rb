module Drivy
  class Car < Application
    attr_accessor :id, :price_per_day, :price_per_km

    def initialize(id, price_per_day, price_per_km)
      @id = id
      @price_per_day = price_per_day
      @price_per_km = price_per_km
    end

    # @return [Array<Object>] with all existing cars
    #   * :id [Integer]
    #   * :price_per_day [Integer]
    #   * :price_per_km [Integer]
    def self.all
      json_datas['cars'].map do |car|
        new(car['id'], car['price_per_day'], car['price_per_km'])
      end
    end

    # @param [Integer] car id
    # @return [Object] with specified car
    def self.find(id)
      all.select { |car| car.id == id }[0]
    end
  end
end
