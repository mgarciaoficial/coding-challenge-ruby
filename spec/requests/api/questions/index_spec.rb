require 'rails_helper'

describe 'GET api/questions/', type: :request do
  before do
    get api_questions_path, headers: headers, as: :json
  end
  let(:headers) { { 'X-API-KEY' => api_key } }

  context 'when no api_key is provided' do
    let(:api_key) { nil }

    it 'returns 401 Unauthorized status' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when an invalid key is provided' do
    let(:api_key) { 'madeInRohan'}

    it 'returns 401 Unauthorized status' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when an valid key is provided' do
    let(:api_key) { Tenant.pluck(:api_key).sample }

    it 'returns 200 OK status' do
      expect(response).to have_http_status(:ok)
    end
  
    it 'complies to json:api conventions' do
      expect(json).to match_response_schema("questions")
    end
  
    # Author's note: specs are run against seed data
    it 'fetches shared questions only' do
      expect(json.dig(:data, :questions).length).to eq(24)
    end
  end
end
