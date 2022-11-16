RSpec.describe Phone, type: 'request' do
  describe 'GET /index' do
    it 'return http successfully' do
      create(:phone)

      get '/phones', headers: { accept: 'application/vnd.api+json' }

      expect(response.content_type).to include 'application/vnd.api+json'
      expect(response).to have_http_status :ok
    end

    it 'renders json with phones' do
      phone = create(:phone)

      get '/phones', headers: { accept: 'application/vnd.api+json' }

      json_response = JSON.parse(response.body, symbolize_names: true)[:data].first[:attributes]
      expect(json_response[:number]).to eq phone.number
      expect(json_response[:'contact-id']).to eq phone.contact_id
    end
  end

  describe 'GET /show' do
    it 'return http successfully' do
      phone = create(:phone)

      get "/phones/#{phone.id}", headers: { accept: 'application/vnd.api+json' }

      expect(response.content_type).to include 'application/vnd.api+json'
      expect(response).to have_http_status :ok
    end

    it 'renders json with phone' do
      phone = create(:phone)

      get "/phones/#{phone.id}", headers: { accept: 'application/vnd.api+json' }

      json_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      expect(json_response[:number]).to eq phone.number
      expect(json_response[:'contact-id']).to eq phone.contact_id
    end
  end

  describe 'POST /create' do
    context 'with valids data' do
      it 'return http successfully' do
        contact = create(:contact)

        post '/phones', headers: { accept: 'application/vnd.api+json' },
                        params: { phone: { number: '(99)9999-9999', contact_id: contact.id } }

        expect(response.content_type).to include 'application/vnd.api+json'
        expect(response).to have_http_status :created
      end

      it 'renders json with phone created' do
        contact = create(:contact)
        phone = { number: '(99)9999-9999', contact_id: contact.id }

        post '/phones', headers: { accept: 'application/vnd.api+json' }, params: { phone: }

        json_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
        expect(json_response[:number]).to eq phone[:number]
        expect(response).to have_http_status :created
      end
    end

    context 'with invalids data' do
      it 'return http successfully' do
        contact = create(:contact)

        post '/phones', headers: { accept: 'application/vnd.api+json' },
                        params: { phone: { number: nil, contact_id: contact.id } }

        expect(response.content_type).to include 'application/vnd.api+json'
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders json with errors' do
        contact = create(:contact)
        phone = { number: nil, contact_id: contact.id }

        post '/phones', headers: { accept: 'application/vnd.api+json' }, params: { phone: }

        json_response = JSON.parse(response.body)
        expect(json_response.key?('number')).to be true
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valids data' do
      it 'return http successfully' do
        phone = create(:phone, number: '(99) 9999-9999')

        patch "/phones/#{phone.id}", headers: { accept: 'application/vnd.api+json' },
                                     params: { phone: { number: '(11) 9999-9999' } }

        expect(response.content_type).to include 'application/vnd.api+json'
        expect(response).to have_http_status :ok
      end

      it 'return json with phone updated' do
        phone = create(:phone, number: '(99) 9999-9999')

        patch "/phones/#{phone.id}", headers: { accept: 'application/vnd.api+json' },
                                     params: { phone: { number: '(11) 9999-9999' } }

        json_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
        expect(json_response[:number]).to eq '(11) 9999-9999'
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroy a register' do
      phone = create(:phone, number: '(11) 9999-9999')

      delete "/phones/#{phone.id}", headers: { accept: 'application/vnd.api+json' }

      expect(response).to have_http_status :no_content
      expect(described_class.all.any?).to be false
    end
  end
end
