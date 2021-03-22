class DashboardController < ApplicationController
  def show
    @akash = Akash::Client.new
    @block_height = @akash.status['SyncInfo']['latest_block_height']
    @block_time = @akash.status['SyncInfo']['latest_block_time']
  end
end
