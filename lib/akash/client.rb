module Akash
  class Client
    attr_accessor :network, :key_name, :home_directory
    attr_reader :cli

    def initialize(keyring_password = nil)
      @network = ENV['AKASH_NET']
      @key_name = ENV['KEY_NAME']
      @home_directory = ENV['AKASH_HOME']
      @cli = CLI.new(network, home_directory, keyring_password)
    end

    def wallet
      @wallet ||= Wallet.new(cli, key_name)
    end

    def deployments
      @deployments ||= Deployments.new(cli, wallet)
    end

    def status
      @status ||= cli.cmd_json('akash status', node: true)
    end
  end
end
