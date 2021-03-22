module Akash
  class Client
    attr_accessor :network, :key_name, :home_directory

    def initialize
      @network = ENV['AKASH_NET']
      @key_name = ENV['KEY_NAME']
      @home_directory = '/root/akash'
    end

    def wallet
      @wallet ||= Wallet.new(cli, key_name)
    end

    def cli
      @cli ||= CLI.new(network, home_directory)
    end

    def status
      @status ||= cli.cmd_json("akash status", node: true)
    end
  end
end
