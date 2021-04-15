module Akash
  class CLI
    attr_accessor :network, :home_directory, :keyring_password

    def initialize(network, home_directory, keyring_password = nil)
      @network = network
      @home_directory = home_directory
      @keyring_password = keyring_password
    end

    def keyring_exists?
      File.exist?(keyring_directory) && !Dir.empty?(keyring_directory)
    end

    def delete_keyring
      FileUtils.remove_dir(keyring_directory)
    end

    def keyring_directory
      File.join(home_directory, 'keyring-file')
    end

    def rpc_node
      return ENV['RPC_NODE'] if ENV['RPC_NODE'].present?

      @rpc_node ||= tty.run("curl -s #{network_url}/rpc-nodes.txt | sort -R | head -1").out.strip
    end

    def chain_id
      @chain_id ||= tty.run("curl -s #{network_url}/chain-id.txt").out.strip
    end

    def version
      @version ||= tty.run("curl -s #{network_url}/version.txt").out.strip
    end

    def network_url
      "https://raw.githubusercontent.com/ovrclk/net/master/#{network}"
    end

    def cmd_json(command, **args)
      res = cmd(command, **args)
      JSON.parse(res) if res.present?
    end

    def cmd(command, **args)
      out, err = run(command, **args)
      puts err.inspect if err.present?
      out.strip
    end

    def run(command, input: [], keyring: false, fees: false, **args)
      input.unshift(keyring_password) if keyring || fees
      in_stream = StringIO.new
      input.each { |i| in_stream.puts i }
      in_stream.rewind
      command = build_command(command, keyring: keyring, fees: fees, **args)
      tty.run(command, in: in_stream, pty: true)
    end

    def build_command(command, keyring: false, node: false, fees: false)
      parts = [command]
      parts.push("--home #{home_directory}")
      parts.push('--keyring-backend file') if keyring || fees
      parts.push("--node #{rpc_node}") if node || fees
      parts.push("--chain-id #{chain_id}") if fees
      parts.push("--fees #{fees == true ? Akash::FEE_RATE : fees} --gas=auto") if fees
      parts.join(' ')
    end

    def tty
      @tty ||= TTY::Command.new
    end
  end
end
