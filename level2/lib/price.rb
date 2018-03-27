module Drivy
  class Price
    class << self
      def total_for_rental(rental)
        duration_price = duration_with_reduction_for_rental(rental.duration, rental.car.price_per_day)
        distance_price = distance_for_rental(rental.distance, rental.car.price_per_km)

        (duration_price + distance_price).to_i
      end

      private

      # Return price depends on number of days
      #
      # - price per day decreases by 10% after 1 day
      # - price per day decreases by 30% after 4 days
      # - price per day decreases by 50% after 10 days
      #
      # @return [Float] price for duration
      def duration_with_reduction_for_rental(duration, price_per_day)
        each_days(duration, price_per_day).inject(:+)
      end

      def distance_for_rental(distance, price_per_km)
        distance * price_per_km
      end

      # Different price for each days for rental
      #
      # @return [Array] with the list of prices
      def each_days(duration, price_per_day)
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

          get_discount_price(discount, price_per_day)
        end
      end

      # @return [Float] discounted price
      def get_discount_price(discount, price_per_day)
        (price_per_day - (price_per_day * discount))
      end
    end
  end
end
