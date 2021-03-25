class DeploymentsController < ApplicationController
  before_action :require_wallet

  def index
    @deployments = @akash.deployments
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
    sdl_content = deployment_params[:sdl_content]
    if sdl_content.present? && @akash.deployments.create(content: sdl_content)
      redirect_to deployments_path
    else
      error = 'Please enter your SDL content (deploy.yml)' unless sdl_content.present?
      # improve errors
      error ||= 'Something went wrong (check docker output)'
      redirect_to new_deployment_path, flash: { error: error }
    end
  end

  def update
    @deployment = @akash.deployments.find(params[:id])
    sdl_content = deployment_params[:sdl_content]
    if sdl_content.present? && @deployment.update(content: sdl_content)
      redirect_to deployments_path
    else
      error = 'Please enter your SDL content (deploy.yml)' unless sdl_content.present?
      # improve errors
      error ||= 'Something went wrong (check docker output)'
      redirect_to new_deployment_path, flash: { error: error }
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

  def deployment_params
    params.require(:deployment).permit(:sdl_content)
  end
end
