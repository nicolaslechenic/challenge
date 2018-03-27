module Drivy
  class Rental
    class << self
      # Generate json file
      def output_json
        File.open("#{ROOT_PATH}/output.json", 'w') do |f|
          f.write(JSON.pretty_generate(rentals: json_prices))
        end
      end

      # @return [Array<Object>] with all rentals
      def all_from_json
        JSON_DATA['rentals'].map do |rental|
          car         = Car.find(rental['car_id'])
          start_date  = Date.parse(rental['start_date'])
          end_date    = Date.parse(rental['end_date'])

          new(rental['id'], car, start_date, end_date, rental['distance'])
        end
      end

      private

      def json_prices
        all_from_json.map do |rental|
          {
            id: rental.id,
            price: rental.price
          }
        end
      end
    end

    attr_accessor :id, :car, :start_date, :end_date, :distance

    def initialize(id, car, start_date, end_date, distance)
      @id         = id
      @car        = car
      @start_date = start_date
      @end_date   = end_date
      @distance   = distance
    end

    # @return [Integer] number of days included in the range
    def number_of_days
      (end_date - start_date).to_i + 1
    end

    # @return [Array] with rental prices
    def price
      (duration_price_with_reductions + distance_price).to_i
    end

    private

    # Return price depends on number of days
    #
    # - price per day decreases by 10% after 1 day
    # - price per day decreases by 30% after 4 days
    # - price per day decreases by 50% after 10 days
    #
    # @return [Float] price for duration
    def duration_price_with_reductions
      each_day_prices.inject(:+)
    end

    def distance_price
      distance * car.price_per_km
    end

    # Different price for each days for rental
    #
    # @return [Array] with the list of prices
    def each_day_prices
      Array.new(number_of_days) do |day_index|
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
      price = car.price_per_day

      (price - (price * discount))
    end
  end
end