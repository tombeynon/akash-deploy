class KeplrController < ApplicationController
  skip_before_action :require_keyring_password, only: %i[new create]

  def transfer
    render 'transfer'
  end

end