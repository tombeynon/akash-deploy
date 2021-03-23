class ApplicationController < ActionController::Base
  before_action :set_akash

  private

  def require_wallet
    redirect_to root_path unless @akash.wallet.exists?
  end

  def set_akash
    @akash = Akash::Client.new
    @block_height = @akash.status['SyncInfo']['latest_block_height']
    @block_time = @akash.status['SyncInfo']['latest_block_time']
  end
end
