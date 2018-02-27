module Drivy
  class Fee < Application
    # @param [Object] rental
    # @param [Integer] with amount of total fees
    # @return [Hash] with commission for current rental
    def self.commission(rental, total_fees)
      insurance_fee = insurance_fee(total_fees)
      assistance_fee = assistance_fee(rental)

      {
        insurance_fee: insurance_fee,
        assistance_fee: assistance_fee,
        drivy_fee: drivy_fee(total_fees, insurance_fee, assistance_fee)
      }
    end

    # @return [Object] deductible reduction price
    def self.options(rental)
      return { deductible_reduction: 0 } unless rental.deductible_reduction

      { deductible_reduction: rental.number_of_days * 400 }
    end

    # @param [Object] rental
    # @return [Integer] assistance fee in cents
    def self.assistance_fee(rental)
      rental.number_of_days * 100
    end
    private_class_method :assistance_fee

    # @return [Integer] drivy fee in cents
    def self.drivy_fee(total_fees, insurance_fee, assistance_fee)
      (total_fees - insurance_fee - assistance_fee).to_i
    end
    private_class_method :drivy_fee

    # @return [Integer] insurance fee in cents
    def self.insurance_fee(total_fees)
      (total_fees / 2).to_i
    end
    private_class_method :insurance_fee
  end
end
