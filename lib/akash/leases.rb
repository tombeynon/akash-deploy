module Akash
  class Leases
    attr_reader :cli, :wallet, :dseq
    delegate :each, to: :leases

    def initialize(cli, wallet, dseq)
      @cli = cli
      @wallet = wallet
      @dseq = dseq
    end

    def find(id)
      leases.find { |l| l.provider == id }
    end

    def create(bid: bid)
      result = cli.run("akash tx market lease create -y --from #{wallet.key_name} --owner #{wallet.address} --dseq #{bid.dseq} --oseq #{bid.oseq} --gseq #{bid.gseq} --provider #{bid.provider}", fees: true)
      result.success?
    rescue TTY::Command::ExitError
      false
    end

    def active
      leases.find_all { |l| l.active? }
    end

    def leases
      @leases ||= (data['leases'] || []).reverse.map do |lease|
        Lease.new(cli, wallet, lease)
      end
    end
    alias_method :all, :leases

    def data
      @data ||= cli.cmd_json("akash query market lease list --owner #{wallet.address} --dseq #{dseq} -o json", node: true)
    end
  end
end
