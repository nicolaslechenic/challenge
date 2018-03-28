require 'pry'
module Drivy
  class Rental
    class << self
      # Generate json file
      def output_json
        File.open("#{ROOT_PATH}/output.json", 'w') do |f|
          f.write(JSON.pretty_generate(rental_modifications: json_list))
        end
      end

      # @return [Array<Object>] with all rentals
      def all_from_json
        JSON_DATA['rentals'].map do |rental|
          new(
            id: rental['id'],
            car: rental['car_id'],
            start_date: rental['start_date'],
            end_date: rental['end_date'],
            distance: rental['distance'],
            deductible_reduction: rental['deductible_reduction']
          )
        end
      end

      # @return [Object] with specified rental
      def find_from_json(rental_id)
        rental_found = all_from_json.find { |rental| rental.id == rental_id }
        raise IndexError, format(ERRORS['rental']['invalid_id'], rental_id: rental_id) if rental_found.nil?

        rental_found
      end

      private

      def json_list
        JSON_DATA['rental_modifications'].map do |rental|
          ref_rental = find_from_json(rental['rental_id'])
          saved_rental = ref_rental.dup
          updated_rental = ref_rental.update(rental).dup

          {
            id: rental['id'],
            rental_id: ref_rental.id,
            actions: Action.get_list(updated_rental, saved_rental)
          }
        end
      end
    end

    AUTHORIZED = %i[id car start_date end_date distance deductible_reduction].freeze

    attr_accessor *AUTHORIZED

    def initialize(rental_hash)
      rental_hash.each do |key, value|
        set_variable(key, value)
      end
    end

    # Update the value of instance variable attributes
    # with the content of modifications_hash
    #
    # @return [Object] current rental instance
    def update(modifications_hash)
      modifications_hash.each do |key, value|
        next if %w[id rental_id].include?(key)
        set_variable(key, value)
      end

      self
    end

    # @return [Integer] number of days included in the range
    def duration
      raise RangeError, ERRORS['rental']['date_range'] if end_date < start_date

      (end_date - start_date).to_i + 1
    end

    def deductible_amount
      deductible_reduction ? (duration * 400) : 0
    end

    private

    # @param [String] instance variable attribute name
    # @param [Integer, Date, Boolean] instance variable attribute value
    def set_variable(key, value)
      key = key.to_sym
      return unless AUTHORIZED.include?(key)

      modified_value =
        if %i[start_date end_date].include?(key)
          date_parser(value)
        elsif key == :car
          car_finder(value)
        else
          value
        end

      instance_variable_set("@#{key}", modified_value)
    end

    def car_finder(value)
      if value.is_a?(Integer)
        Car.find_from_json(value)
      elsif value.instance_of?(Car)
        value
      else
        raise TypeError, 'Invalid type for car'
      end
    end

    def date_parser(value)
      if value.instance_of?(Date)
        value
      elsif value.is_a?(String)
        Date.parse(value)
      else
        raise TypeError, 'Invalid type for date'
      end
    end
  end
end
