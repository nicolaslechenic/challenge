module Drivy
  class Action
    # @return [Hash] formatted json actions
    def self.to_json(who, amount)
      operation_type = amount >= 0 ? 'credit' : 'debit'

      {
        who: who,
        type: operation_type,
        amount: amount.abs
      }
    end

    def self.get_list(updated_rental, original_rental)
      amounts = [updated_rental, original_rental].map do |rental|
        price = Price.new_from_rental(rental)
        fee   = Fee.new(price.total, rental.duration)

        driver_amount = -(price.total + rental.deductible_amount)
        owner_amount  = price.total - fee.total
        drivy_amount  = fee.drivy + rental.deductible_amount

        {
          driver: driver_amount,
          owner: owner_amount,
          insurance: fee.insurance,
          assistance: fee.assistance,
          drivy: drivy_amount
        }
      end

      amounts[0].keys.map do |key|
        to_json(key.to_s, amounts[0][key] - amounts[1][key])
      end
    end
  end
end

