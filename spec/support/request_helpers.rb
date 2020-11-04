module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body).with_indifferent_access
    end
  end
end