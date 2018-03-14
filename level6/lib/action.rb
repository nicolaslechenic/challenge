module Drivy
  class Action < Application
    # @return [Hash] formatted json actions
    def self.to_json(who, amount)
      raise ArgumentError, ERRORS['action']['zero_value'] if amount.zero?
      operation_type = amount > 0 ? 'credit' : 'debit'

      {
        who: who,
        type: operation_type,
        amount: amount.abs
      }
    rescue ArgumentError => exception
      print "#{exception.class.name}: #{exception.message}"
    end

    # @return [Array<Hash>] formatted json actions
    def self.get_list(new_amounts, previous_amounts)
      new_commissions = new_amounts[:commissions]
      previous_commissions = previous_amounts[:commissions]

      driver_amount = -(new_amounts[:driver_owe] - previous_amounts[:driver_owe])
      owner_amount  = new_amounts[:owner_part] - previous_amounts[:owner_part]
      insurance_amount = new_commissions[:insurance_fee] - previous_commissions[:insurance_fee]
      assistance_amount = new_commissions[:assistance_fee] - previous_commissions[:assistance_fee]
      drivy_amount = new_commissions[:drivy_fee_with_reduction] - previous_commissions[:drivy_fee_with_reduction]

      [
        to_json('driver', driver_amount),
        to_json('owner', owner_amount),
        to_json('insurance', insurance_amount),
        to_json('assistance', assistance_amount),
        to_json('drivy', drivy_amount)
      ]
    end
  end
end
