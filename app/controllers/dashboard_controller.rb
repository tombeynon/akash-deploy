class DashboardController < ApplicationController
  def show
    @deployments = @akash.deployments.active
  end
end
