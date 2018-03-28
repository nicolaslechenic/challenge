module Drivy
  class Price
    class << self
      def total_for_rental(rental)
        price = new_from_rental(rental)

        (price.for_duration_with_reduction + price.for_distance).to_i
      end

      private

      def new_from_rental(rental)
        new(
          distance:       rental.distance,
          duration:       rental.duration,
          price_per_day:  rental.car.price_per_day,
          price_per_km:   rental.car.price_per_km
        )
      end
    end

    AUTHORIZED = %i[distance duration price_per_day price_per_km].freeze

    attr_accessor *AUTHORIZED

    def initialize(price_hash)
      price_hash.each do |key, value|
        next unless AUTHORIZED.include?(key)
        instance_variable_set("@#{key}", value)
      end
    end

    # Return price depends on number of days
    #
    # - price per day decreases by 10% after 1 day
    # - price per day decreases by 30% after 4 days
    # - price per day decreases by 50% after 10 days
    #
    # @return [Float] price for duration
    def for_duration_with_reduction
      each_days.inject(:+)
    end

    def for_distance
      distance * price_per_km
    end

    private

    # Different price for each days for rental
    #
    # @return [Array] with the list of prices
    def each_days
      Array.new(duration) do |day_index|
        discount =
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

        get_discount_price(discount)
      end
    end

    # @return [Float] discounted price
    def get_discount_price(discount)
      (price_per_day - (price_per_day * discount))
    end
  end
end
