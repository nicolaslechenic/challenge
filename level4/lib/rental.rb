require 'pry'
module Drivy
  class Rental
    class << self
      # Generate json file
      def output_json
        File.open("#{ROOT_PATH}/output.json", 'w') do |f|
          f.write(JSON.pretty_generate(rentals: json_list))
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
            distance: rental['distance'],
            deductible_reduction: rental['deductible_reduction']
          )
        end
      end

      private

      def json_list
        all_from_json.map do |rental|
          price = Price.new_from_rental(rental)
          fee   = Fee.new(price.total, rental.duration)

          {
            id: rental.id,
            price: price.total,
            options: {
              deductible_reduction: rental.deductible_amount
            },
            commission: {
              insurance_fee: fee.insurance,
              assistance_fee: fee.assistance,
              drivy_fee: fee.drivy
            }
          }
        end
      end
    end

    AUTHORIZED = %i[id car start_date end_date distance deductible_reduction].freeze

    attr_accessor *AUTHORIZED

    def initialize(rental_hash)
      rental_hash.each do |key, value|
        next unless AUTHORIZED.include?(key)
        instance_variable_set("@#{key}", value)
      end
    end

    # @return [Integer] number of days included in the range
    def duration
      (end_date - start_date).to_i + 1
    end

    def deductible_amount
      deductible_reduction ? duration * 400 : 0
    end
  end
end
