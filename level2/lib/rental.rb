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

          new(
            id: rental['id'],
            car: car,
            start_date: start_date,
            end_date: end_date,
            distance: rental['distance']
          )
        end
      end

      private

      def json_prices
        all_from_json.map do |rental|
          {
            id: rental.id,
            price: rental.amount.total
          }
        end
      end
    end

    AUTHORIZED = %i[id car start_date end_date distance].freeze

    attr_accessor *AUTHORIZED

    def initialize(rental_hash)
      rental_hash.each do |key, value|
        next unless AUTHORIZED.include?(key)
        instance_variable_set("@#{key}", value)
      end
    end

    # @return [Integer] number of days included in the range
    def number_of_days
      (end_date - start_date).to_i + 1
    end

    def amount
      Amount.new(
        distance: distance,
        duration: number_of_days,
        car: car
      )
    end
  end
end
