module Drivy
  class Action < Application
    # @return [Hash] formatted json actions
    def self.to_json(who, amount)
      operation_type = amount >= 0 ? 'credit' : 'debit'

      {
        who: who,
        type: operation_type,
        amount: amount.abs
      }
    end
  end
end
