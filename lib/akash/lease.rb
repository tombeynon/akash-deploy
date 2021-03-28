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

    def closed?
      state == 'closed'
    end

    def manifest_active?
      services.any?
    end

    def state
      data.dig('lease', 'state')
    end

    def dseq
      data.dig('lease', 'lease_id', 'dseq')
    end

    def gseq
      data.dig('lease', 'lease_id', 'gseq')
    end

    def oseq
      data.dig('lease', 'lease_id', 'oseq')
    end

    def provider
      data.dig('lease', 'lease_id', 'provider')
    end

    def price
      data.dig('lease', 'price')
    end

    def uris
      services.map(&:uris).flatten
    end

    def services
      return [] unless status_data['services']

      status_data['services'].map do |key, data|
        Service.new(key, data)
      end
    end

    def send_manifest(manifest_path)
      result = cli.run("akash provider send-manifest #{manifest_path} --from #{wallet.key_name} --dseq #{dseq} --provider #{provider}", node: true, keyring: true)
      result.success? && result.err.blank?
    rescue TTY::Command::ExitError
      false
    end

    def close
      result = cli.run("akash tx market lease close -y --from #{wallet.key_name} --owner #{wallet.address} --dseq #{dseq} --oseq #{oseq} --gseq #{gseq} --provider #{provider}", fees: true)
      result.success?
    rescue TTY::Command::ExitError
      false
    end

    def escrow
      @escrow ||= EscrowPayment.new(data.dig('escrow_payment'))
    end

    def status_data
      return {} unless wallet.certificate.exists?

      @status_data ||= cli.cmd_json("akash provider lease-status --from #{wallet.key_name} --dseq #{dseq} --oseq #{oseq} --gseq #{gseq} --provider #{provider}", node: true, keyring: true) || {}
    end
  end
end
