module Drivy
  class Rental < Application
    attr_accessor :id, :car_id, :start_date, :end_date, :distance, :deductible_reduction
    # List of attributes
    #
    #   * :id [Integer]
    #   * :car_id [Integer]
    #   * :start_date [String] with following format "yyyy-mm-dd"
    #   * :end_date [String] with following format "yyyy-mm-dd"
    #   * :distance [Integer]
    #   * :deductible_reduction [Boolean]
    def initialize(rental_hash)
      rental_hash.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # @return [Integer] number of days included in the range
    def number_of_days
      start_date  = Date.parse(self.start_date)
      end_date    = Date.parse(self.end_date)

      (end_date - start_date).to_i + 1
    end

    # @return [Array<Object>] with all rentals
    def self.all
      json_datas['rentals'].map do |rental|
        new(rental)
      end
    end

    # @return [Array<Hash>] with the desired output values
    def self.outputs
      all.map.with_index do |rental, index|
        price_before_reduction = price_before_reduction(rental)
        total_fees = price_before_reduction * 0.3
        commissions = Fee.commission(rental, total_fees)
        rental_amount = price_after_reduction(rental, price_before_reduction)

        {
          id: index + 1,
          actions: [
            json_action('driver', 'debit', rental_amount),
            json_action('owner', 'credit', (price_before_reduction - total_fees).to_i),
            json_action('insurance', 'credit', commissions[:insurance_fee]),
            json_action('assistance', 'credit', commissions[:assistance_fee]),
            json_action('drivy', 'credit', commissions[:drivy_fee_with_reduction])
          ]
        }
      end
    end

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

    # @return [Hash] formatted json actions
    def self.json_action(who, operation_type, amount)
      {
        who: who,
        type: operation_type,
        amount: amount
      }
    end
    private_class_method :json_action

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
