module Akash
  class Deployments
    attr_reader :cli, :wallet
    delegate :each, to: :deployments

    def initialize(cli, wallet)
      @cli = cli
      @wallet = wallet
    end

    def find(id)
      deployments.find { |d| d.dseq == id }
    end

    def new(data = {})
      Deployment.new(cli, wallet, data)
    end

    def create(content: nil, file: nil)
      path = file&.path || File.join(cli.home_directory, 'deploy.yml')
      File.write(path, content) if content.present?
      create_deployment(path)
    end

    def active
      deployments.find_all { |d| d.active? }
    end

    def deployments
      @deployments ||= (data['deployments'] || []).reverse.map do |deploy|
        new(deploy)
      end
    end
    alias_method :all, :deployments

    def data
      return {} unless wallet.exists?

      @data ||= cli.cmd_json("akash query deployment list --owner #{wallet.address} -o json", node: true)
    end

    private

    def create_deployment(manifest_path)
      result = cli.run("akash tx deployment create #{manifest_path} -y --from #{wallet.key_name}", fees: true)
      return false unless result.success?

      json = JSON.parse(result.out)
      dseq = json['logs'][0]['events'][0]['attributes'].find{ |d| d['key'] == 'dseq' }['value']
      File.rename(manifest_path, File.join(cli.home_directory, "#{dseq}.yml"))
      true
    rescue TTY::Command::ExitError
      false
    end
  end
end
