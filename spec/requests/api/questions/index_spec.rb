require 'rails_helper'

describe 'GET api/questions/', type: :request do
  before do
    get api_questions_path, as: :json
  end

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
