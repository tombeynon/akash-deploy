class DeploymentsController < ApplicationController
  before_action :require_wallet
  before_action :require_certificate, only: %i[new edit create update]
  before_action :require_funds, only: %i[new edit create update destroy]
  before_action :require_escrow_funds, only: %i[new create]

  def index
    if params[:state] == 'closed'
      @deployments = @akash.deployments.closed
    else
      @deployments = @akash.deployments.active
    end
  end

  def show
    @deployment = @akash.deployments.find(params[:id])
  end

  def new
    @deployment = @akash.deployments.new
  end

  def edit
    @deployment = @akash.deployments.find(params[:id])
  end

  def create
    manifest_content = deployment_params[:manifest_content]
    if manifest_content.present? && @akash.deployments.create(content: manifest_content)
      redirect_to deployments_path
    else
      error = 'Please enter your manifest content (deploy.yml)' unless manifest_content.present?
      # improve errors
      error ||= 'Something went wrong (check docker output)'
      redirect_to new_deployment_path, flash: { error: error }
    end
  end

  def update
    @deployment = @akash.deployments.find(params[:id])
    manifest_content = deployment_params[:manifest_content]
    if manifest_content.present? && @deployment.update(content: manifest_content)
      redirect_to deployment_path(@deployment.dseq)
    else
      error = 'Please enter your manifest content (deploy.yml)' unless manifest_content.present?
      # improve errors
      error ||= 'Something went wrong (check docker output)'
      redirect_to edit_deployment_path(@deployment.dseq), flash: { error: error }
    end
  end

  def destroy
    @deployment = @akash.deployments.find(params[:id])
    if @deployment.close
      redirect_to deployment_path(@deployment.dseq), flash: { notice: "Deployment ##{@deployment.dseq} closed" }
    else
      redirect_to deployment_path(@deployment.dseq), flash: { notice: 'Something went wrong (check docker output)' }
    end
  end

  private

  def require_escrow_funds
    return if @akash.wallet.balance('uakt') > Akash.escrow_amount_uakt

    redirect_to wallet_path, flash: { error: "Deployment requires #{Akash.escrow_amount_uakt}uakt escrow" }
  end

  def deployment_params
    params.require(:deployment).permit(:manifest_content, :deploy_amount)
  end
end
