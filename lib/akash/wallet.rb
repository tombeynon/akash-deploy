module Akash
  class Wallet
    attr_reader :cli, :key_name

    def initialize(cli, key_name)
      @cli = cli
      @key_name = key_name
    end

    def exists?
      address.present?
    end

    def address
      @address ||= cli.cmd("akash keys show #{key_name} -a", keyring: true)
    rescue TTY::Command::ExitError
    end

    def balances
      return unless exists?

      cli.cmd_json("akash query bank balances #{address} -o json", node: true)['balances']
    end

    def create
      input = []
      input.unshift('y') if exists?
      out, err = cli.run("akash keys add #{key_name}", input: input, keyring: true)
      err
    end

    def restore(recovery_phrase)
      input = [recovery_phrase]
      input.unshift('y') if exists?
      out, err = cli.run("akash keys add #{key_name} --recover", input: input, keyring: true)
      out
    end
  end
end
