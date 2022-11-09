RSpec.describe Kind, type: 'request' do
  describe 'GET /index' do
    it 'return http successfully' do
      create(:kind)

      get '/kinds'

      expect(response.content_type).to include 'application/json'
      expect(response).to have_http_status :ok
    end

    it 'renders a json with kinds' do
      kind = create(:kind)

      get '/kinds'

      json_response = JSON.parse(response.body, symbolize_names: true)[:data].first[:attributes]
      expect(json_response[:description]).to eq kind.description
    end
  end

  describe 'GET /show' do
    it 'return http successfully' do
      kind = create(:kind)

      get "/kinds/#{kind.id}"

      expect(response.content_type).to include 'application/json'
      expect(response).to have_http_status :ok
    end

    it 'renders a json with kind' do
      kind = create(:kind)

      get "/kinds/#{kind.id}"

      json_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      expect(json_response[:description]).to eq kind.description
    end
  end

  describe 'POST /create' do
    context 'with valids data' do
      it 'renders http successfully' do
        kind = { description: 'generic description' }

        post '/kinds', params: { kind: }

        expect(response.content_type).to include 'application/json'
        expect(response).to have_http_status :created
      end

      it 'renders kind created' do
        kind = { description: 'generic description' }

        post '/kinds', params: { kind: }

        json_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
        expect(json_response[:description]).to eq kind[:description]
      end
    end

    context 'with invalids data' do
      it 'does not create a kind' do
        kind = { description: nil }

        post '/kinds', params: { kind: }

        expect(response.content_type).to include 'application/json'
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders the errors' do
        kind = { description: nil }

        post '/kinds', params: { kind: }

        json_response = JSON.parse(response.body)
        expect(json_response.key?('description')).to be true
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid data' do
      it 'render http successfully' do
        kind = create(:kind)

        patch "/kinds/#{kind.id}", params: { kind: { description: 'description updated' } }

        expect(response.content_type).to include 'application/json'
        expect(response).to have_http_status :ok
      end

      it 'renders a updated kind' do
        kind = create(:kind)

        patch "/kinds/#{kind.id}", params: { kind: { description: 'description updated' } }

        json_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
        expect(json_response[:description]).to eq 'description updated'
      end
    end

    context 'with invalids data' do
      it 'render http successfully' do
        kind = create(:kind)

        patch "/kinds/#{kind.id}", params: { kind: { description: nil } }

        expect(response.content_type).to include 'application/json'
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders the errors' do
        kind = create(:kind)

        patch "/kinds/#{kind.id}", params: { kind: { description: nil } }

        json_response = JSON.parse(response.body)
        expect(json_response.key?('description')).to be true
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroy a kind' do
      kind = create(:kind)

      delete "/kinds/#{kind.id}"

      expect(response).to have_http_status :no_content
      expect(described_class.all.any?).to be false
    end
  end
end
