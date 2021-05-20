# placeholder for transfering token from akash deploy to keplr :)
module Akash
  class Send
    attr_reader :cli, :key_name, :receiver_key

    def initialize(cli, key_name, receiver_key)
      @cli = cli
      @key_name = key_name
      @receiver_key = receiver_key
    end

    def send(amount):
      input = []
      input.push(cli.keyring_password)
      cli.run("akash tx send #{key_name} #{receiver_key} #{amount}uakt -y --keyring-backend file", input: input)
    end

  end
end
