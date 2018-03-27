module Drivy
  class Rental < Application
    class << self
      # Generate json file
      def output_json
        File.open("#{ROOT_PATH}/output.json", 'w') do |f|
          f.write(JSON.pretty_generate(rentals: json_prices))
        end
      end

      # @return [Array<Object>] with all rentals
      def all_from_json
        json_data['rentals'].map do |rental|
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
    def count_days
      (end_date - start_date).to_i + 1
    end

    # @return [Array] with rental prices
    def price
      (duration_price + distance_price).to_i
    end

    private

      def duration_price
        count_days * car.price_per_day
      end

      def distance_price
        distance * car.price_per_km
      end
  end
end
