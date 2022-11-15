RSpec.describe Address, type: 'request' do
  describe 'GET /index' do
    it 'return http successfully' do
      create(:address)

      get '/addresses'

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
    end

    it 'renders the addresses' do
      address = create(:address)

      get '/addresses'

      json_response = JSON.parse(response.body, symbolize_names: true).first[1][0][:attributes]
      expect(json_response[:street]).to eq address.street
      expect(json_response[:city]).to eq address.city
    end
  end

  describe 'GET /show' do
    it 'return http successfully' do
      address = create(:address)

      get "/addresses/#{address.id}"

      expect(response.content_type).to include 'application/json'
      expect(response).to have_http_status :ok
    end

    it 'renders a address' do
      address = create(:address)

      get "/addresses/#{address.id}"

      json_response = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(json_response[:attributes][:street]).to eq address.street
      expect(json_response[:attributes][:city]).to eq address.city
      expect(json_response[:relationships][:contact][:links][:related]).to include "contacts/#{address.id}"
    end
  end

  describe 'POST /create' do
    context 'with valids data' do
      it 'return http successfully' do
        address = { street: 'Rua dos Bobos', city: 'Pindorama', contact_id: create(:contact).id }

        post '/addresses', params: { address: }

        expect(response.content_type).to include 'application/json'
        expect(response).to have_http_status :created
      end

      it 'renders an address' do
        address = { street: 'Rua dos Bobos', city: 'Pindorama', contact_id: create(:contact).id }

        post '/addresses', params: { address: }

        json_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
        expect(json_response[:street]).to eq 'Rua dos Bobos'
        expect(json_response[:city]).to eq 'Pindorama'
      end
    end

    context 'with invalids data' do
      it 'return http successfully' do
        address = { street: nil, city: 'Pindorama', contact_id: nil }

        post '/addresses', params: { address: }

        expect(response.content_type).to include 'application/json'
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders the errors' do
        address = { street: nil, city: 'Pindorama', contact_id: nil }

        post '/addresses', params: { address: }

        json_response = JSON.parse(response.body)
        expect(json_response['contact'].any?).to be true
        expect(json_response['street'].any?).to be true
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valids data' do
      it 'return http successfully' do
        address = create(:address)

        patch "/addresses/#{address.id}", params: { address: { city: 'Ratanamba' } }

        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'
      end

      it 'renders an anddress' do
        address = create(:address)

        patch "/addresses/#{address.id}", params: { address: { city: 'Ratanamba' } }

        json_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
        expect(json_response[:city]).to eq 'Ratanamba'
      end
    end

    context 'with invalids data' do
      it 'return http successfully' do
        address = create(:address)

        patch "/addresses/#{address.id}", params: { address: { city: nil } }

        expect(response).to have_http_status :unprocessable_entity
        expect(response.content_type).to include 'application/json'
      end

      it 'renders an anddress' do
        address = create(:address)

        patch "/addresses/#{address.id}", params: { address: { city: nil } }

        json_response = JSON.parse(response.body)
        expect(json_response['city'].any?).to be true
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroy an address' do
      address = create(:address)

      delete "/addresses/#{address.id}"

      expect(response).to have_http_status :no_content
      expect(described_class.any?).to be false
    end
  end
end
