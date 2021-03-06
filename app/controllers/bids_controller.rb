class BidsController < ApplicationController
  before_action :require_wallet
  before_action :require_certificate, only: %i[new edit create update destroy]
  before_action :require_funds, only: %i[new edit create update destroy]

  before_action :set_deployment

  def index
    @bids = @deployment.bids
  end

  private

  def set_deployment
    @deployment = @akash.deployments.find(params[:deployment_id])
  end
end
