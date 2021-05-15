class FundsController < ApplicationController
  def new
    @deployment = @akash.deployments.find(params[:deployment_id])
  end

  def create
    @deployment = @akash.deployments.find(params[:deployment_id])
    deposit_amount = fund_params[:deposit_amount].split('uakt').first
    if @deployment.fund(deposit_amount)
      redirect_to deployment_path(@deployment.dseq), flash: { notice: "Deployment funded with #{deposit_amount}uakt" }
    else
      redirect_to new_deployment_fund_path(@deployment.dseq), flash: { error: 'Unable to fund deployment' }
    end
  end

  private

  def fund_params
    params.require(:fund).permit(:deposit_amount)
  end
end
