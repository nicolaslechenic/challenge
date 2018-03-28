module Drivy
  class Action
    # @return [Hash] formatted json actions
    def self.to_json(who, operation_type, amount)
      {
        who: who,
        type: operation_type,
        amount: amount
      }
    end
  end
end
