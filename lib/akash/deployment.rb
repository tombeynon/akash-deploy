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

    def sdl_exists?
      File.exist?(sdl_path)
    end

    def dseq
      data.dig('deployment', 'deployment_id', 'dseq')
    end

    def state
      data.dig('deployment', 'state')
    end

    def sdl_content
      File.read(sdl_path) if sdl_exists?
    end

    def sdl_path
      File.join(cli.home_directory, "#{dseq}.yml")
    end

    def update(content: nil, file: nil)
      path = file&.path || File.join(cli.home_directory, "#{dseq}.yml")
      File.write(path, content) if content.present?
      update_deployment(path)
    end

    def close
      close_deployment
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

    private

    def update_deployment(sdl_path)
      result = cli.run("akash tx deployment update #{sdl_path} --dseq #{dseq} -y --from #{wallet.key_name}", fees: true)
      result.success?
    rescue TTY::Command::ExitError
      false
    end

    def close_deployment
      result = cli.run("akash tx deployment close --dseq #{dseq} -y --from #{wallet.key_name}", fees: true)
      return false unless result.success?

      File.delete(sdl_path) if sdl_exists?
      true
    rescue TTY::Command::ExitError
      false
    end
  end
end
