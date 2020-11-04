# frozen_string_literal: true

class Api::ApplicationController < ActionController::API
  before_action :track_request

  protected

  def track_request
    # track request logic goes in here
  end
end
