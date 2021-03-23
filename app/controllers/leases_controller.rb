class LeasesController < ApplicationController
  before_action :require_wallet
  before_action :set_deployment

  def index
    @leases = @deployment.leases
  end

  def show
    @lease = @deployment.leases.find(params[:id])
  end

  private

  def set_deployment
    @deployment = @akash.deployments.find(params[:deployment_id])
  end
end
