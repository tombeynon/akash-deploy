module Akash
  class Bids
    attr_reader :cli, :wallet, :dseq
    delegate :each, to: :bids

    def initialize(cli, wallet, dseq)
      @cli = cli
      @wallet = wallet
      @dseq = dseq
    end

    def find(id)
      bids.find { |l| l.provider == id }
    end

    def active
      bids.find_all { |l| l.active? }
    end

    def bids
      @bids ||= (data['bids'] || []).reverse.map do |lease|
        Bid.new(cli, wallet, lease)
      end
    end
    alias_method :all, :bids

    def data
      @data ||= cli.cmd_json("akash query market bid list --owner #{wallet.address} --dseq #{dseq} -o json", node: true)
    end
  end
end
