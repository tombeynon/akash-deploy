class CertificatesController < ApplicationController
  before_action :require_wallet

  def create
    if certificate_params[:content].present?
      @akash.wallet.certificate.restore(certificate_params[:content])
    else
      @akash.wallet.certificate.create
    end
    redirect_to wallet_path
  end

  def destroy
    @akash.wallet.certificate.revoke && @akash.wallet.certificate.delete
    redirect_to wallet_path
  end

  private

  def certificate_params
    params.fetch(:certificate, {}).permit(:content)
  end
end
