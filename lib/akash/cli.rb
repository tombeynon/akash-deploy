module Akash
  class CLI
    attr_accessor :network, :home_directory

    def initialize(network, home_directory)
      @network = network
      @home_directory = home_directory
    end

    def rpc_node
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
      JSON.parse(cmd(command, **args))
    end

    def cmd(command, **args)
      out, err = run(command, **args)
      raise err.inspect if err.present?
      out.strip
    end

    def run(command, input: nil, **args)
      if input.is_a?(Array)
        in_stream = StringIO.new
        input.each { |i| in_stream.puts i }
        in_stream.rewind
        tty.run(build_command(command, **args), in: in_stream, pty: true)
      else
        tty.run(build_command(command, **args), input: input, pty: true)
      end
    end

    private

    def build_command(command, home: false, keyring: false, node: false, fees: false)
      parts = [command]
      parts.push("--home #{home_directory}")
      parts.push("--keyring-backend test") if keyring || fees # insecure backend
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
