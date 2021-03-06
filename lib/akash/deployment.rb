module Akash
  class Deployment
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

    def active_lease?
      return false unless active?

      active_lease.present?
    end

    def manifest_active?
      return false unless active_lease?

      active_lease.manifest_active?
    end

    def manifest_exists?
      File.exist?(manifest_path)
    end

    def persisted?
      dseq.present?
    end

    def dseq
      data.dig('deployment', 'deployment_id', 'dseq')
    end

    def state
      data.dig('deployment', 'state')
    end

    def uris
      return [] unless active_lease?
      active_lease.uris
    end

    def ports
      return [] unless active_lease?
      active_lease.ports
    end

    def manifest_content
      File.read(manifest_path) if manifest_exists?
    end

    def manifest_path
      File.join(cli.home_directory, "#{dseq}.yml")
    end

    def fund(amount_uakt = 10_000)
      result = cli.run("akash tx deployment deposit #{amount_uakt}uakt --dseq #{dseq} -y --from #{wallet.key_name}", fees: true)
      result.success?
    rescue TTY::Command::ExitError
      false
    end

    def update(content: nil, file: nil)
      path = file&.path || File.join(cli.home_directory, "#{dseq}.yml")
      File.write(path, content) if content.present?
      update_deployment(path)
    end

    def close
      close_deployment
    end

    def active_lease
      @active_lease ||= leases.active.first
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

    def bids
      @bids ||= Bids.new(cli, wallet, dseq)
    end

    private

    def update_deployment(manifest_path)
      result = cli.run("akash tx deployment update #{manifest_path} --dseq #{dseq} -y --from #{wallet.key_name}", fees: true)
      result.success?
    rescue TTY::Command::ExitError
      false
    end

    def close_deployment
      result = cli.run("akash tx deployment close --dseq #{dseq} -y --from #{wallet.key_name}", fees: true)
      result.success?
    rescue TTY::Command::ExitError
      false
    end
  end
end
