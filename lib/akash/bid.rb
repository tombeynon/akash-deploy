module Akash
  class Bid
    attr_reader :cli, :wallet, :data

    def initialize(cli, wallet, data)
      @cli = cli
      @wallet = wallet
      @data = data
    end

    def active?
      state == 'active'
    end

    def state
      data.dig('bid', 'state')
    end

    def dseq
      data.dig('bid', 'bid_id', 'dseq')
    end

    def gseq
      data.dig('bid', 'bid_id', 'gseq')
    end

    def oseq
      data.dig('bid', 'bid_id', 'oseq')
    end

    def provider
      data.dig('bid', 'bid_id', 'provider')
    end

    def price
      data.dig('bid', 'price')
    end

    def escrow
      @escrow ||= EscrowAccount.new(data.dig('escrow_account'))
    end
  end
end
