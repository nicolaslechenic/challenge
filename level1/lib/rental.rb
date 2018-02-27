module Drivy
  class Rental < Application
    attr_accessor :id, :car_id, :start_date, :end_date, :distance

    def initialize(id, car_id, start_date, end_date, distance)
      @id = id
      @car_id = car_id
      @start_date = start_date
      @end_date = end_date
      @distance = distance
    end

    # @return [Array<Object>] with all rentals
    #   * :id [Integer]
    #   * :car_id [Integer]
    #   * :start_date [String] with following format "yyyy-mm-dd"
    #   * :end_date [String] with following format "yyyy-mm-dd"
    #   * :distance [Integer]
    def self.all
      json_datas['rentals'].map do |rental|
        new(rental['id'], rental['car_id'], rental['start_date'], rental['end_date'], rental['distance'])
      end
    end

    # @return [Integer] number of days included in the range
    def count_days
      start_date  = Date.parse(self.start_date)
      end_date    = Date.parse(self.end_date)

      (end_date - start_date).to_i + 1
    end

    # @return [Array] with rental prices
    def self.prices
      all.map do |rental|
        car = Car.find(rental.car_id)
        duration_price = price_for_number_of_days(rental, car.price_per_day)
        distance_price = distance_price(rental, car.price_per_km)

        (duration_price + distance_price).to_i
      end
    end

    # @param [Hash] rental informations
    # @param [Integer] price per day
    # @return [Integer] price for range date
    def self.price_for_number_of_days(rental, price_per_day)
      rental.count_days * price_per_day
    end

    def self.distance_price(rental, price_per_km)
      rental.distance * price_per_km
    end

    private_class_method :distance_price
    private_class_method :price_for_number_of_days
  end
end
