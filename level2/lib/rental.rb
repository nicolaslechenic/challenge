module Drivy
  class Rental < Application
    attr_accessor :id, :car_id, :start_date, :end_date, :distance
    # List of attributes
    #
    #   * :id [Integer]
    #   * :car_id [Integer]
    #   * :start_date [String] with following format "yyyy-mm-dd"
    #   * :end_date [String] with following format "yyyy-mm-dd"
    #   * :distance [Integer]
    def initialize(rental_hash)
      rental_hash.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # @return [Integer] number of days included in the range
    def number_of_days
      start_date  = Date.parse(self.start_date)
      end_date    = Date.parse(self.end_date)

      (end_date - start_date).to_i + 1
    end

    # @return [Array<Object>] with all rentals
    def self.all
      json_datas['rentals'].map do |rental|
        new(rental)
      end
    end

    # @return [Array] with rentals prices
    def self.prices
      all.map do |rental|
        car = Car.find(rental.car_id)
        duration_price = price_after_decreases(rental, car.price_per_day)
        distance_price = distance_price(rental, car.price_per_km)

        (duration_price + distance_price).to_i
      end
    end

    # Price for specified distance
    def self.distance_price(rental, price_per_km)
      rental.distance * price_per_km
    end
    private_class_method :distance_price

    # Different price for each days
    #
    # @param [Integer] number of days
    # @param [Integer] price per day before discounted
    # @return [Array] with the list of prices
    def self.each_day_prices(number_of_days, price)
      Array.new(number_of_days) do |day_index|
        factor =
          case day_index
          when 0
            0.0
          when 1..3
            0.1
          when 4..9
            0.3
          else
            0.5
          end

        get_discount_price(price, factor)
      end
    end
    private_class_method :each_day_prices

    # @return [Float] discounted price
    def self.get_discount_price(price, discount)
      (price - (price * discount))
    end
    private_class_method :get_discount_price

    # Return price depends on number of days
    #
    # - price per day decreases by 10% after 1 day
    # - price per day decreases by 30% after 4 days
    # - price per day decreases by 50% after 10 days
    #
    # @param [Object] rental informations
    # @param [Integer] price per day
    # @return [Float] price for duration
    def self.price_after_decreases(rental, price_per_day)
      number_of_days = rental.number_of_days

      each_day_prices(number_of_days, price_per_day).inject(:+)
    end
    private_class_method :price_after_decreases
  end
end
