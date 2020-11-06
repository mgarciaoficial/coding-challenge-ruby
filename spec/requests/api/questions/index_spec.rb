require 'rails_helper'

describe 'GET api/questions/', type: :request do  
  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
    
    get api_questions_path, headers: headers, as: :json
  end
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
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

    it 'updates tenant count' do
      expect(Tenant.find_by(api_key: api_key).req_count).to eq(1)
    end

    context 'and 100 a day req count free limit is reached' do
      before do
        cache_key = "#{I18n.l(Time.current.to_date, format: :default)}_#{api_key}"
        Rails.cache.write(cache_key, 100)
      end
  
      it 'returns 200 OK status' do
        expect(response).to have_http_status(:ok)
      end

      context 'and another request hit less than ten seconds ago' do
        before do
          get api_questions_path, headers: headers, as: :json
          Timecop.travel(9.seconds.from_now)
        end
    
        it 'returns 200 OK status' do
          get api_questions_path, headers: headers, as: :json
          expect(response).to have_http_status(:service_unavailable)
        end
      end

      context 'and another request hit more than ten seconds ago' do
        before do
          get api_questions_path, headers: headers, as: :json
          Timecop.travel(10.seconds.from_now)
        end
    
        it 'returns 200 OK status' do
          get api_questions_path, headers: headers, as: :json
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
