module Akash
  class Deployments
    attr_reader :cli, :wallet

    def initialize(cli, wallet)
      @cli = cli
      @wallet = wallet
    end

    def find(id)
      get_deployments(dseq: id).first
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
      @active ||= get_deployments(state: 'active')
    end

    def closed
      @closed ||= get_deployments(state: 'closed')
    end

    def all
      @all ||= get_deployments
    end

    def get_deployments(state: nil, dseq: nil)
      return {} unless wallet.exists?

      flags = []
      flags << "--state #{state}" if state
      flags << "--dseq #{dseq}" if dseq
      data = cli.cmd_json("akash query deployment list --owner #{wallet.address} #{flags.join(' ')} -o json", node: true)
      (data['deployments'] || []).reverse.map do |deploy|
        new(deploy)
      end
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
