module Akash
  class Certificate
    attr_reader :cli, :key_name, :certificate_name

    def initialize(cli, key_name, certificate_name)
      @cli = cli
      @key_name = key_name
      @certificate_name = certificate_name
    end

    def exists?
      File.exist?(path)
    end

    def to_s
      File.read(path)
    end

    def restore(content)
      File.write(path, content)
    end

    def delete
      File.delete(path)
    end

    def create
      cli.run("akash tx cert create client -y --rie --from=#{key_name}", keyring: true, fees: true)
    end

    def revoke
      cli.run("akash tx cert revoke -y --from=#{key_name}", keyring: true, fees: true)
    end

    def filename
      "#{certificate_name}.pem"
    end

    def path
      File.join(cli.home_directory, filename)
    end
  end
end
