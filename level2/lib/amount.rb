module Drivy
  class Amount
    AUTHORIZED = %i[distance duration car].freeze

    attr_accessor *AUTHORIZED

    # @param [Integer] distance in kilometers
    # @param [Integer] duration in days
    def initialize(amount_hash)
      amount_hash.each do |key, value|
        next unless AUTHORIZED.include?(key)
        instance_variable_set("@#{key}", value)
      end
    end

    def total
      (duration_with_reduction_price + distance_price).to_i
    end

    private

    # Return price depends on number of days
    #
    # - price per day decreases by 10% after 1 day
    # - price per day decreases by 30% after 4 days
    # - price per day decreases by 50% after 10 days
    #
    # @return [Float] price for duration
    def duration_with_reduction_price
      each_days.inject(:+)
    end

    def distance_price
      distance * car.price_per_km
    end

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
      (car.price_per_day - (car.price_per_day * discount))
    end
  end
end
