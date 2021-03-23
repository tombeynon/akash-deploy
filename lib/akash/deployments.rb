module Akash
  class Deployments
    attr_reader :cli, :wallet
    delegate :each, to: :deployments

    def initialize(cli, wallet)
      @cli = cli
      @wallet = wallet
    end

    def deployments
      @deployments ||= (data['deployments'] || []).map do |deploy|
        Deployment.new(deploy)
      end
    end
    alias_method :all, :deployments

    def active
      deployments.find_all { |d| d.active? }
    end

    def data
      return {} unless wallet.exists?

      @data ||= cli.cmd_json("akash query deployment list --owner #{wallet.address} -o json", node: true)
    end
  end
end
