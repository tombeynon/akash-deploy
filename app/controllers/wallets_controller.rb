class WalletsController < ApplicationController
  def show
    @akash = Akash::Client.new
  end

  def new
    @akash = Akash::Client.new
  end

  def create
    @akash = Akash::Client.new
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
