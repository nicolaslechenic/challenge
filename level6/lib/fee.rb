module Drivy
  class Fee < Application
    def self.commission(rental, total_fees)
      insurance_fee   = insurance_fee(total_fees)
      assistance_fee  = assistance_fee(rental)
      reduction_fee   = deductible_reduction_amount(rental)

      {
        insurance_fee: insurance_fee,
        assistance_fee: assistance_fee,
        drivy_fee_with_reduction: drivy_fee_with_reduction(total_fees, insurance_fee, assistance_fee, reduction_fee)
      }
    end

    # @param [Object] instance of rental
    # @return [Integer] deductible reduction price
    def self.deductible_reduction_amount(rental)
      rental.deductible_reduction ? rental.number_of_days * OPTION_PRICE_PER_DAY : 0
    end

    # @param [Object] instance of rental
    # @return [Integer] assistance fee in cents
    def self.assistance_fee(rental)
      rental.number_of_days * ASSISTANCE_FEE_PER_DAY
    end
    private_class_method :assistance_fee

    # @return [Integer] drivy fee with reduction in cents
    def self.drivy_fee_with_reduction(total_fees, insurance_fee, assistance_fee, reduction_fee)
      total_fees - insurance_fee - assistance_fee + reduction_fee
    end
    private_class_method :drivy_fee_with_reduction

    # @return [Integer] insurance fee in cents
    def self.insurance_fee(total_fees)
      (total_fees / 2).to_i
    end
    private_class_method :insurance_fee
  end
end
