class PasswordsController < ApplicationController
  skip_before_action :require_keyring_password

  def new
    redirect_to new_wallet_path unless @akash.cli.keyring_exists?
  end

  def create
    unless valid_keyring_password?(password_params[:keyring_password])
      return redirect_to new_password_path, flash: {alert: 'Please enter a valid password'}
    end

    @akash = Akash::Client.new(password_params[:keyring_password])
    if @akash.wallet.exists?
      set_keyring_password(password_params[:keyring_password])
      redirect_to root_path
    else
      redirect_to new_password_path, flash: {alert: 'Incorrect password'}
    end

  end

  def destroy
    delete_keyring_password
    redirect_to new_password_path, flash: {notice: 'Wallet closed'}
  end

  private

  def password_params
    params.require(:password).permit(:keyring_password)
  end
end
