module Akash
  FEE_RATE = ENV['FEE_RATE'] || '5000uakt'

  def self.fee_rate_uakt
    FEE_RATE.split('uakt')[0].to_i
  end
end
