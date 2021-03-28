class LogsController < ApplicationController
  before_action :require_wallet

  def show
    @deployment = @akash.deployments.find(params[:deployment_id])
    @lease = @deployment.leases.find(params[:lease_id])
    unless @deployment && @lease
      redirect_to deployment_page(@deployment.dseq), flash: {alert: 'Deployment or lease not found'}
    end
  end
end
