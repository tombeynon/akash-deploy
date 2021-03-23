module Akash
  class Deployment
    class Escrow
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def balance
        data['balance']
      end

      def transferred
        data['transferred']
      end
    end

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def active?
      state == 'active'
    end

    def dseq
      data.dig('deployment', 'deployment_id', 'dseq')
    end

    def state
      data.dig('deployment', 'state')
    end

    def escrow
      Escrow.new(data.dig('escrow_account'))
    end

    def groups
      data.dig('groups')
    end
  end
end
