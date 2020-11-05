# frozen_string_literal: true

class Api::ApplicationController < ActionController::API
  before_action :authenticate_tenant, :track_request

  rescue_from UnauthError, with: :render_unauth

  protected

  def authenticate_tenant
    api_key = request.headers['X-API-KEY']
    raise UnauthError, 'Invalid key' unless Tenant.exists?(api_key: api_key)
  end

  def track_request
    # track request logic goes in here
  end

  private

  def render_unauth(exception)
    render json: { message: exception.message }, status: :unauthorized
  end

end
