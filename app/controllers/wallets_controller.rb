class WalletsController < ApplicationController
  def show
  end

  def new
  end

  def create
    if wallet_params[:recovery_phrase].present?
      @output = @akash.wallet.restore(wallet_params[:recovery_phrase])
    else
      @output = @akash.wallet.create
    end
  end

  private

  def wallet_params
    params.require(:wallet).permit(:recovery_phrase)
  end
end
