module Akash
  class Deployment
    class EscrowAccount
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

    class Group
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def name
        data.dig('group_spec', 'name')
      end

      def resources
        data.dig('group_spec', 'resources').map do |resource|
          {
            cpu: resource.dig('resources', 'cpu', 'units', 'val'),
            memory: resource.dig('resources', 'memory', 'quantity', 'val'),
            storage: resource.dig('resources', 'storage', 'quantity', 'val'),
          }
        end
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
      data.dig('deployment', 'state')
    end

    def dseq
      data.dig('deployment', 'deployment_id', 'dseq')
    end

    def escrow
      @escrow ||= EscrowAccount.new(data.dig('escrow_account'))
    end

    def groups
      @groups ||= data.dig('groups').map { |group| Group.new(group) }
    end

    def leases
      @leases ||= Leases.new(cli, wallet, dseq)
    end
  end
end
