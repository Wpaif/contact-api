RSpec.describe 'Contact', type: 'request' do
  describe 'GET /index' do
    it 'return http successfully' do
      get '/contacts'

      expect(response.content_type).to include 'application/json'
      expect(response).to have_http_status :ok
    end

    it 'renders all contacts registereds' do
      contact = create :contact

      get '/contacts'

      json_response = JSON.parse(response.body).first
      expect(json_response['name']).to eq contact.name
      expect(json_response['email']).to eq contact.email
      expect(json_response['birthdate']).to eq I18n.l(contact.birthdate)
    end
  end

  describe 'GET /show' do
    it 'return http succssfully' do
      contact = create :contact

      get "/contacts/#{contact.id}"

      expect(response.content_type).to include 'application/json'
      expect(response).to have_http_status :ok
    end

    it 'renders a Contact' do
      contact = create :contact

      get "/contacts/#{contact.id}"

      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq contact.name
      expect(json_response['email']).to eq contact.email
      expect(json_response['birthdate']).to eq I18n.l(contact.birthdate)
    end
  end

  describe 'POST /create' do
    context 'with valids data' do
      it 'return http successfully' do
        contact = { name: 'Wilian Ferrera', email: 'wilian@mail.com',
                    birthdate: Time.zone.today - 18.years }

        post '/contacts', params: { contact: }

        expect(response).to have_http_status :created
        expect(response.content_type).to include 'application/json'
      end

      it 'renders a contact' do
        contact = { name: 'Wilian Ferrera', email: 'wilian@mail.com',
                    birthdate: Time.zone.today - 18.years }

        post '/contacts', params: { contact: }

        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq contact[:name]
        expect(json_response['email']).to eq contact[:email]
        expect(json_response['birthdate']).to eq I18n.l(contact[:birthdate])
      end
    end

    context 'with invalids data' do
      it 'not registers contact' do
        contact = { name: 'Wilian', email: 'wilian@mail.com', birthdate: nil }

        post '/contacts', params: { contact: }

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valids data' do
      it 'return http successfully' do
        contact = create :contact

        patch "/contacts/#{contact.id}", params: { contact: { name: 'Wilian Ferreira' } }

        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'
      end

      it 'renders the contact registered' do
        contact = create :contact

        patch "/contacts/#{contact.id}", params: { contact: { name: 'Wilian Ferreira' } }

        json_response = JSON.parse(response.body)
        contact.reload
        expect(json_response['name']).to eq contact[:name]
      end
    end

    context 'with invalids data' do
      it 'no update contact' do
        contact = create :contact

        patch "/contacts/#{contact.id}", params: { contact: { name: nil } }

        expect(response).to have_http_status :unprocessable_entity
        expect(response.content_type).to include 'application/json'
      end

      it 'renders json errors messages' do
        contact = create :contact

        patch "/contacts/#{contact.id}", params: { contact: { name: nil } }

        json_response = JSON.parse(response.body)
        expect(json_response.any?).to be true
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroy a contact' do
      contact = create :contact

      delete "/contacts/#{contact.id}"

      expect(response).to have_http_status :no_content
    end
  end
end
