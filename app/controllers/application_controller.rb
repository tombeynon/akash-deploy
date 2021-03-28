class ApplicationController < ActionController::Base
  before_action :set_akash
  before_action :require_keyring_password
  after_action :extend_keyring_password, if: :keyring_password?

  private

  def keyring_password?
    keyring_password.present?
  end
  helper_method :keyring_password?

  def valid_keyring_password?(password)
    return false unless password.present?

    password.length >= 8
  end

  def keyring_password
    cookies.signed[:keyring_password]
  end

  def extend_keyring_password
    set_keyring_password(keyring_password)
  end

  def set_keyring_password(password)
    cookies.signed[:keyring_password] = {
      value: password,
      expires: 1.hour.from_now
    }
  end

  def delete_keyring_password
    cookies.delete :keyring_password
  end

  def require_keyring_password
    return if keyring_password.present?
    return redirect_to new_wallet_path unless @akash && @akash.cli.keyring_exists?

    redirect_to new_password_path
  end

  def require_funds
    redirect_to wallet_path, flash: {alert: 'Please fund your wallet first'} unless @akash.wallet.funded?
  end

  def require_wallet
    redirect_to root_path, flash: {alert: 'Wallet required'} unless @akash.wallet.exists?
  end

  def require_certificate
    redirect_to wallet_path, flash: {alert: 'Certificate required'} unless @akash.wallet.certificate.exists?
  end

  def set_akash
    @akash = Akash::Client.new(keyring_password)
  end
end
