class WalletsController < ApplicationController
  skip_before_action :require_keyring_password, only: %i[new create]

  def create
    unless @akash.cli.keyring_exists?
      unless valid_keyring_password?(wallet_params[:keyring_password])
        return redirect_to new_wallet_path, flash: {alert: 'Please enter a valid password'}
      end
      set_keyring_password(wallet_params[:keyring_password])
      @akash = Akash::Client.new(wallet_params[:keyring_password])
    end
    @output = if wallet_params[:recovery_phrase].present?
                @akash.wallet.restore(wallet_params[:recovery_phrase])
              else
                @akash.wallet.create
              end
  end

  def destroy
    @akash.wallet.delete

    redirect_to root_path, flash: { notice: 'Wallet deleted' }
  end

  private

  def wallet_params
    params.fetch(:wallet, {}).permit(:keyring_password, :recovery_phrase)
  end
end
