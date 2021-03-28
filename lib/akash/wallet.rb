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

    def certificate
      @certificate ||= Certificate.new(cli, key_name, address)
    end

    def address
      return unless cli.keyring_password.present?

      @address ||= cli.cmd("akash keys show #{key_name} -a", keyring: true)
    rescue TTY::Command::ExitError
    end

    def balances
      return unless exists?

      cli.cmd_json("akash query bank balances #{address} -o json", node: true)['balances']
    end

    def create
      input = []
      input.push(cli.keyring_password)
      if cli.keyring_exists?
        input.push('y')
      else
        input.push(cli.keyring_password)
      end
      out, err = cli.run("akash keys add #{key_name}", input: input, keyring: true)
      err
    end

    def restore(recovery_phrase)
      input = []
      input.push(recovery_phrase)
      if cli.keyring_exists?
        input.push(cli.keyring_password)
        input.push('y')
      else
        input.push(cli.keyring_password)
        input.push(cli.keyring_password)
      end
      out, err = cli.run("akash keys add #{key_name} --recover --keyring-backend file", input: input)
      out
    end

    def delete
      input = []
      input.push(cli.keyring_password)
      cli.run("akash keys delete #{key_name} -y --keyring-backend file", input: input)
    end
  end
end
