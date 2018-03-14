module Drivy
  class Rental < Application
    attr_accessor :id, :car, :start_date, :end_date, :distance, :deductible_reduction

    # List of attributes
    #
    #   * :id [Integer]
    #   * :car [Object]
    #   * :start_date [Date]
    #   * :end_date [Date]
    #   * :distance [Integer]
    #   * :deductible_reduction [Boolean]
    def initialize(rental_hash)
      rental_hash.each { |key, value| set_variable(key, value) }
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

    def number_of_days
      raise RangeError, ERRORS['rental']['date_range'] if end_date < start_date

      (end_date - start_date).to_i + 1
    end

    # All amounts for specified rental
    #
    # @param [Object] rental instance
    # @return [Hash] with list of prices
    #   * :driver_owe [Integer] total price paid by the driver
    #   * :owner_part [Integer] 70% of the price goes to the car owner
    #   * :commissions [Hash] with insurance, assistance and drivy fees
    def amounts
      total_fees = (total_amount_without_option * FEES_ON_PRICE_PER_ONE).to_i

      {
        driver_owe: total_amount_with_option,
        owner_part: total_amount_without_option - total_fees,
        commissions: Fee.commission(self, total_fees)
      }
    end

    def distance_amount
      distance * car.price_per_km
    end

    # Return price depends on number of days
    #
    # - price per day decreases by 10% after 1 day
    # - price per day decreases by 30% after 4 days
    # - price per day decreases by 50% after 10 days
    #
    # @param [Object] rental informations
    # @param [Integer] price per day
    # @return [Float] price for duration
    def duration_amount
      each_day_amounts.inject(:+)
    end

    # Different price for each days
    #
    # @param [Integer] number of days
    # @param [Integer] price per day before discounted
    # @return [Array] with the list of prices
    def each_day_amounts
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

        get_discount_amount(factor)
      end
    end

    # @return [Float] discounted price
    def get_discount_amount(discount)
      price = car.price_per_day
      (price - (price * discount)).to_i
    end

    # @param [Object] rental
    # @param [Integer] price before applying deductible_reduction_amount
    # @return [Integer] with rental price after applying deductible_reduction_amount
    def total_amount_with_option
      deductible_reduction_amount = Fee.deductible_reduction_amount(self)

      total_amount_without_option + deductible_reduction_amount
    end

    # @return [Integer] with rental price before applying deductible_reduction_amount
    def total_amount_without_option
      duration_amount + distance_amount
    end

    # @return [Array<Object>] with all rentals
    def self.all
      json_datas['rentals'].map { |rental| new(rental) }
    end

    # @return [Object] with specified rental
    def self.find(rental_id)
      rental_found = all.find { |rental| rental.id == rental_id }
      raise IndexError, format(ERRORS['rental']['invalid_id'], rental_id: rental_id) if rental_found.nil?

      rental_found
    end

    # @return [Array<Hash>] with the desired output values
    def self.output_modifications
      json_datas['rental_modifications'].map do |rental|
        ref_rental = find(rental['rental_id'])
        saved_rental = ref_rental.dup
        new_rental = ref_rental.update(rental).dup

        {
          id: rental['id'],
          rental_id: ref_rental.id,
          actions: Action.get_list(new_rental.amounts, saved_rental.amounts)
        }
      end
    end

    private

    # @param [String] instance variable attribute name
    # @param [Integer, Date, Boolean] instance variable attribute value
    def set_variable(key, value)
      return unless WHITELIST_RENTAL_ATTR.include?(key)

      modified_value =
        if %w[start_date end_date].include?(key)
          Date.parse(value)
        elsif key == 'car_id'
          key = 'car'
          Car.find(value)
        else
          value
        end

      instance_variable_set("@#{key}", modified_value)
    end
  end
end
