module Drivy
  class Rental < Application
    attr_accessor :id, :car_id, :start_date, :end_date, :distance, :deductible_reduction
    # List of attributes
    #
    #   * :id [Integer]
    #   * :car_id [Integer]
    #   * :start_date [Date]
    #   * :end_date [Date]
    #   * :distance [Integer]
    #   * :deductible_reduction [Boolean]
    def initialize(rental_hash)
      rental_hash.each do |key, value|
        set_variable(key, value)
      end
    end

    # Update the value of instance variable attributes 
    # with the content of modifications_hash
    def update(modifications_hash)
      modifications_hash.each do |key, value|
        next if %w[id rental_id].include? key
        set_variable(key, value)
      end

      self
    end

    # @return [Integer] number of days included in the range
    def number_of_days
      (end_date - start_date).to_i + 1
    end

    # @param [String] instance variable attribute name
    # @param [Integer, Date, Boolean] instance variable attribute value
    def set_variable(key, value)
      if %w[start_date end_date].include? key
        instance_variable_set("@#{key}", Date.parse(value))
      else
        instance_variable_set("@#{key}", value)
      end
    end

    # @return [Array<Object>] with all rentals
    def self.all
      json_datas['rentals'].map do |rental|
        new(rental)
      end
    end

    # @param [Integer] rental id
    # @return [Object] with specified rental
    def self.find(id)
      all.select { |rental| rental.id == id }[0]
    end

    # @return [Array<Hash>] with the desired output values
    def self.output_modifications
      json_datas['rental_modifications'].map.with_index do |rental, index|
        ref_rental = find(rental['rental_id'])
        saved_rental = ref_rental.dup
        new_rental = ref_rental.update(rental)

        saved_prices = prices(saved_rental)
        new_prices = prices(new_rental)

        saved_commissions = Fee.commission(saved_rental, saved_prices[:total_fees])
        new_commissions = Fee.commission(new_rental, new_prices[:total_fees])

        {
          id: index + 1,
          rental_id: ref_rental.id,
          actions: [
            Action.to_json('driver', -(new_prices[:rental_amount] - saved_prices[:rental_amount]).to_i),
            Action.to_json('owner', (new_prices[:to_owner] - saved_prices[:to_owner]).to_i),
            Action.to_json('insurance', (new_commissions[:insurance_fee] - saved_commissions[:insurance_fee]).to_i),
            Action.to_json('assistance', (new_commissions[:assistance_fee] - saved_commissions[:assistance_fee]).to_i),
            Action.to_json('drivy', (new_commissions[:drivy_fee_with_reduction] - saved_commissions[:drivy_fee_with_reduction]).to_i)
          ]
        }
      end
    end

    # TODO
    #
    # @param [Object] rental instance
    # @return [Hash] with list of prices
    def self.prices(rental)
      before_reduction = price_before_reduction(rental)
      total_fees = before_reduction * 0.3
      rental_amount = price_after_reduction(rental, before_reduction)

      {
        before_reduction: before_reduction,
        total_fees: total_fees,
        rental_amount: rental_amount,
        to_owner: before_reduction - total_fees
      }
    end
    private_class_method :prices

    # @param [Object] rental
    # @return [Integer] with rental price before applying deductible_reduction_amount
    def self.price_before_reduction(rental)
      car = Car.find(rental.car_id)
      duration_amount = price_after_decreases(rental, car.price_per_day)
      distance_amount = distance_amount(rental, car.price_per_km)

      (duration_amount + distance_amount).to_i
    end
    private_class_method :price_before_reduction

    # @param [Object] rental
    # @param [Integer] price before applying deductible_reduction_amount
    # @return [Integer] with rental price after applying deductible_reduction_amount
    def self.price_after_reduction(rental, price_before_reduction)
      deductible_reduction_amount = Fee.deductible_reduction_amount(rental)

      (price_before_reduction + deductible_reduction_amount).to_i
    end
    private_class_method :price_after_reduction

    # Price for specified distance
    def self.distance_amount(rental, price_per_km)
      rental.distance * price_per_km
    end
    private_class_method :distance_amount

    # Different price for each days
    #
    # @param [Integer] number of days
    # @param [Integer] price per day before discounted
    # @return [Array] with the list of prices
    def self.each_day_amounts(number_of_days, price)
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

        get_discount_amount(price, factor)
      end
    end
    private_class_method :each_day_amounts

    # @return [Float] discounted price
    def self.get_discount_amount(price, discount)
      (price - (price * discount))
    end
    private_class_method :get_discount_amount

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

      each_day_amounts(number_of_days, price_per_day).inject(:+)
    end
    private_class_method :price_after_decreases
  end
end
