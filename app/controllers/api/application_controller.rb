# frozen_string_literal: true

class Api::ApplicationController < ActionController::API
  before_action :authenticate_tenant, :track_request

  rescue_from UnauthError, with: :render_unauth

  protected

  # We need tenant record to track req count
  # Try to find it, and rescue from not found error and raise proper unauth error
  def authenticate_tenant
    api_key = request.headers['X-API-KEY']
    @current_tenant = Tenant.find_by! api_key: api_key
  rescue ActiveRecord::RecordNotFound
    raise UnauthError, 'Invalid key'
  end

  def track_request
    # Lets make sure we keep a real track of requests per tenant.
    @current_tenant.with_lock do
      @current_tenant.update req_count: @current_tenant.req_count + 1
    end
  end

  private

  def render_unauth(exception)
    render json: { message: exception.message }, status: :unauthorized
  end
end