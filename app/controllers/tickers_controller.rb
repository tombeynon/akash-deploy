class TickersController < ApplicationController
  skip_before_action :require_keyring_password, only: %i[new create]

  def akash
    render 'akash'
  end

end