module Akash
  FEE_RATE = ENV['FEE_RATE'] || '5000uakt'
  ESCROW_AMOUNT = '5000000uakt'.freeze

  def self.fee_rate_uakt
    FEE_RATE.split('uakt')[0].to_i
  end

  def self.escrow_amount_uakt
    ESCROW_AMOUNT.split('uakt')[0].to_i
  end
end
