class DeploymentsController < ApplicationController
  before_action :require_wallet

  def index
    @deployments = @akash.deployments
  end

  def show
    @deployment = @akash.deployments.find(params[:id])
  end
end
