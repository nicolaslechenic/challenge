module Drivy
  class Fee
    TOTAL_FEES_PER_ONE  = 0.3
    EURO_TO_CENTS_RATIO = 100

    attr_accessor :amount, :duration

    def initialize(amount, duration)
      @amount = amount
      @duration = duration
    end

    def total
      (amount * TOTAL_FEES_PER_ONE).to_i
    end

    def insurance
      (total / 2).to_i
    end

    def assistance
      (duration * EURO_TO_CENTS_RATIO).to_i
    end

    def drivy
      total - (insurance + assistance)
    end
  end
end
