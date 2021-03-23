module Akash
  class Lease
    class EscrowPayment
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def rate
        data['rate']
      end

      def balance
        data['balance']
      end

      def withdrawn
        data['withdrawn']
      end
    end

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
      data.dig('lease', 'state')
    end

    def provider
      data.dig('lease', 'lease_id', 'provider')
    end

    def price
      data.dig('lease', 'price')
    end

    def escrow
      @escrow ||= EscrowPayment.new(data.dig('escrow_payment'))
    end
  end
end
