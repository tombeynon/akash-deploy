class KeyringsController < ApplicationController
  skip_before_action :require_keyring_password

  def destroy
    @akash.cli.delete_keyring
    delete_keyring_password
    redirect_to new_password_path, flash: {notice: 'Keyring deleted'}
  end
end
