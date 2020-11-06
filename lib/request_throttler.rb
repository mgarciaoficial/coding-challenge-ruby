# frozen_string_literal: true

class RequestThrottler

  def initialize(app, free_limit, freeze_time)
    @app = app
    @free_limit = free_limit
    @freeze_time = freeze_time
  end

  def call(env)
    request = ActionDispatch::Request.new env
    api_key = request.headers['X-API-KEY']

    cache_key = "#{I18n.l(Time.current.to_date, format: :default)}_#{api_key}"
    throttle_key = "#{cache_key}_throttled"

    if Rails.cache.read(throttle_key)
      [503, { "Content-Type" => request.headers['Content-Type'] }, []]
    else
      update_req_count(cache_key, throttle_key)
      @app.call(env)
    end
  end

  private

  def update_req_count(cache_key, throttle_key)
    today_requests = Rails.cache.read(cache_key) || 0
    today_requests += 1
    Rails.cache.write(cache_key, today_requests, expires_in: 1.day) # Tomorrow will use a different key, no need to expire exactly at EOD
    Rails.cache.write(throttle_key, true, expires_in: @freeze_time.seconds) if today_requests >= @free_limit
  end
end