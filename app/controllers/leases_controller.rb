class LeasesController < ApplicationController
  before_action :require_wallet
  before_action :require_certificate, only: %i[new edit create update destroy]
  before_action :require_funds, only: %i[new edit create update destroy]

  before_action :set_deployment

  def index
    @leases = @deployment.leases
  end

  def show
    @lease = @deployment.leases.find(params[:id])
  end

  def new
    @bid = @deployment.bids.find(params[:provider])
  end

  def create
    provider = lease_params[:provider]
    @bid = @deployment.bids.find(provider)
    if @bid && @deployment.leases.create(bid: @bid)
      redirect_to deployment_lease_path(@deployment.dseq, provider), flash: { notice: 'Lease created - you should now send your manifest to the provider' }
    else
      error = 'Provider is required' unless @bid
      # improve errors
      error ||= 'Something went wrong (check docker output)'
      redirect_to new_deployment_lease_path(@deployment.dseq, provider: provider), flash: { error: error }
    end
  end

  def update
    unless @deployment.manifest_exists?
      redirect_to deployment_lease_path(@deployment.dseq, @lease.provider), flash: { error: 'Deploy certificate is not configured. Check the Wallet page' }
    end

    @lease = @deployment.leases.find(params[:id])
    if @lease.send_manifest(@deployment.manifest_path)
      redirect_to deployment_lease_path(@deployment.dseq, @lease.provider), flash: { notice: 'Manifest updated' }
    else
      redirect_to deployment_lease_path(@deployment.dseq, @lease.provider), flash: { error: 'Something went wrong (check docker output)' }
    end
  end

  def destroy
    @lease = @deployment.leases.find(params[:id])
    if @lease.close
      redirect_to deployment_lease_path(@deployment.dseq, @lease.provider), flash: { notice: "Lease closed" }
    else
      redirect_to deployment_lease_path(@deployment.dseq, @lease.provider), flash: { error: 'Something went wrong (check docker output)' }
    end
  end

  private

  def set_deployment
    @deployment = @akash.deployments.find(params[:deployment_id])
  end

  def lease_params
    params.require(:lease).permit(:provider)
  end
end
