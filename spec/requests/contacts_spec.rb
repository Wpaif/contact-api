RSpec.describe 'Contact', type: 'request' do
  describe 'GET /index' do
    it 'return http successfully' do
      get '/contacts'

      expect(response.content_type).to include 'application/json'
      expect(response).to have_http_status :ok
    end

    it 'renders all contacts registereds' do
      contact = create(:contact)

      get '/contacts'

      json_response = JSON.parse(response.body, symbolize_names: true).first[1][0]
      expect(json_response[:attributes][:name]).to eq contact.name
      expect(json_response[:attributes][:email]).to eq contact.email
      expect(json_response[:attributes][:birthdate]).to eq contact.birthdate.to_time.iso8601
    end
  end

  describe 'GET /show' do
    it 'return http succssfully' do
      contact = create(:contact)

      get "/contacts/#{contact.id}"

      expect(response.content_type).to include 'application/json'
      expect(response).to have_http_status :ok
    end

    it 'renders a Contact' do
      contact = create(:contact)

      get "/contacts/#{contact.id}"

      json_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      expect(json_response[:name]).to eq contact.name
      expect(json_response[:email]).to eq contact.email
      expect(json_response[:birthdate]).to eq contact.birthdate.to_time.iso8601
    end
  end

  describe 'POST /create' do
    context 'with valids data' do
      it 'return http successfully' do
        contact = { name: 'Wilian Ferrera', email: 'wilian@mail.com',
                    birthdate: Time.zone.today - 18.years, kind_id: create(:kind).id }

        post '/contacts', params: { contact: }

        expect(response).to have_http_status :created
        expect(response.content_type).to include 'application/json'
      end

      it 'return http sucesfully when nested phones is include' do
        contact = {
          name: 'Wilian Ferreira', email: 'wilian@main.com', birthdate: '1990-01-01',
          kind_id: create(:kind).id, phones_attributes: [{ number: '(99) 9999-9999' },
                                                         { number: '(88) 8888-8888' }]
        }

        post '/contacts', params: { contact: }

        expect(response.content_type).to include 'application/json'
        expect(response).to have_http_status :created
        expect(Contact.find(1).phones.any?).to be true
      end

      it 'return http sucesfully when nested address is include' do
        contact = {
          name: 'Wilian Ferreira', email: 'wilian@main.com', birthdate: '1990-01-01',
          kind_id: create(:kind).id, address_attributes: { city: 'Ratanabá', street: 'Rua Zero' }
        }

        post '/contacts', params: { contact: }

        expect(response.content_type).to include 'application/json'
        expect(response).to have_http_status :created
      end

      it 'renders a contact' do
        contact = { name: 'Wilian Ferrera', email: 'wilian@mail.com',
                    birthdate: Time.zone.today - 18.years, kind_id: create(:kind).id }

        post '/contacts', params: { contact: }

        json_response = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(json_response[:attributes][:name]).to eq contact[:name]
        expect(json_response[:attributes][:email]).to eq contact[:email]
        expect(json_response[:attributes][:birthdate]).to eq contact[:birthdate].to_time.iso8601
        expect(json_response[:relationships].keys.sort).to eq %i[phones address kind].sort
      end
    end

    context 'with invalids data' do
      it 'return http successfully' do
        contact = { name: 'Wilian', email: 'wilian@mail.com', birthdate: nil, kind_id: create(:kind).id }

        post '/contacts', params: { contact: }

        expect(response).to have_http_status :unprocessable_entity
        expect(response.content_type).to include 'application/json'
      end

      it 'return http sucesfully when nested phones is include' do
        contact = {
          name: 'Wilian Ferreira', email: 'wilian@main.com', birthdate: '1990-01-01', kind_id: create(:kind).id,
          phones_attributes: [{ number: 'asdfa' }]
        }

        post '/contacts', params: { contact: }

        expect(response.content_type).to include 'application/json'
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'return http sucesfully when nested address is include' do
        contact = {
          name: 'Wilian Ferreira', email: 'wilian@main.com', birthdate: '1990-01-01',
          kind_id: create(:kind).id, address_attributes: { steet: nil, city: nil }
        }

        post '/contacts', params: { contact: }

        expect(response.content_type).to include 'application/json'
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'renders the errors' do
        contact = { name: 'Wilian', email: 'wilian@mail.com', birthdate: nil, kind_id: create(:kind).id }

        post '/contacts', params: { contact: }

        json_response = JSON.parse(response.body)
        expect(json_response.any?).to be true
      end

      it 'renders the errors with nested phone' do
        contact = { name: 'Wilian Ferreira', email: 'wilian@main.com', birthdate: '1990-01-01',
                    kind_id: create(:kind).id, phones_attributes: [{ number: 'asdfa' }] }

        post '/contacts', params: { contact: }

        json_response = JSON.parse(response.body)
        expect(json_response.key?('phones.number')).to be true
      end

      it 'renders the errors with nested address' do
        contact = { name: 'Wilian Ferreira', email: 'wilian@main.com', birthdate: '1990-01-01',
                    kind_id: create(:kind).id, address_attributes: { city: nil, street: nil } }

        post '/contacts', params: { contact: }

        json_response = JSON.parse(response.body)
        expect(json_response.key?('address.street')).to be true
        expect(json_response.key?('address.city')).to be true
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valids data' do
      it 'return http successfully' do
        contact = create(:contact)

        patch "/contacts/#{contact.id}", params: { contact: { name: 'Wilian Ferreira' } }

        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'
      end

      it 'return http sucesfully when phones attributes is include' do
        contact = create(:contact, phones_attributes: [{ number: '(99) 9999-9999' }])

        patch "/contacts/#{contact.id}", params: { contact: { phones_attributes: [{ id: 1, number: '(88) 8888-8888' }] } }

        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'
      end

      it 'return http sucesfully when address attributes is include' do
        contact = create(:contact, address_attributes: { city: 'Ratanabá', street: 'Rua Zero' })

        patch "/contacts/#{contact.id}", params: { contact: { address_attributes: { id: 1, street: 'Rua Um' } } }

        expect(response).to have_http_status :ok
        expect(response.content_type).to include 'application/json'
      end

      it 'renders the contact registered' do
        contact = create(:contact)

        patch "/contacts/#{contact.id}", params: { contact: { name: 'Wilian Ferreira' } }

        json_response = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
        contact.reload
        expect(json_response[:name]).to eq contact[:name]
      end

      it 'renders contact json when nesteds attributes is include' do
        contact = create(:contact, phones_attributes: [{ number: '(99) 9999-9999' }])

        phones_attributes = [{ id: 1, number: '(88) 9999-9999' }]
        patch "/contacts/#{contact.id}", params: { contact: { phones_attributes: } }

        json_response = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(json_response[:relationships][:phones][:data][0][:id].to_i).to eq contact.phones[0].id
      end
    end

    context 'with invalids data' do
      it 'return http successfully' do
        contact = create(:contact)

        patch "/contacts/#{contact.id}", params: { contact: { name: nil } }

        expect(response).to have_http_status :unprocessable_entity
        expect(response.content_type).to include 'application/json'
      end

      it 'return http successfully when phones atributes is include' do
        contact = create(:contact, phones_attributes: [{ number: '(99) 9999-9999' }])

        patch "/contacts/#{contact.id}", params: { contact: { phones_attributes: [{ id: 1, number: nil }] } }

        expect(response).to have_http_status :unprocessable_entity
        expect(response.content_type).to include 'application/json'
      end

      it 'return http successfully when address atributes is include' do
        contact = create(:contact, address_attributes: { city: 'Ratanabá', street: 'Rua Zero' })

        patch "/contacts/#{contact.id}", params: { contact: { address_attributes: { id: 1, street: nil } } }

        expect(response).to have_http_status :unprocessable_entity
        expect(response.content_type).to include 'application/json'
      end

      it 'renders the errors' do
        contact = create(:contact)

        patch "/contacts/#{contact.id}", params: { contact: { name: nil } }

        json_response = JSON.parse(response.body)
        expect(json_response.any?).to be true
      end

      it 'renders the errors when phones attributes is includes' do
        contact = create(:contact, phones_attributes: [{ number: '(99) 9999-9999' }])

        patch "/contacts/#{contact.id}", params: { contact: { phones_attributes: [{ id: 1, number: nil }] } }

        json_response = JSON.parse(response.body)
        expect(json_response.key?('phones.number')).to be true
      end

      it 'renders the errors when address attributes is includes' do
        contact = create(:contact, address_attributes: { city: 'Ratanabá', street: 'Rua Zero' })

        patch "/contacts/#{contact.id}", params: { contact: { address_attributes: { id: 1, street: nil } } }

        json_response = JSON.parse(response.body)
        expect(json_response.key?('address.street')).to be true
      end
    end

    context 'when destroy a nested phone' do
      it 'with sucessfully' do
        contact = create(:contact, phones_attributes: [{ number: '(99) 9999-9999' }, { number: '(88) 8888-8888' }])

        patch "/contacts/#{contact.id}", params: { contact: { phones_attributes: [{ id: 1, _destroy: 1 }] } }

        json_response = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(json_response[:relationships][:phones][:data].first[:id].to_i).to eq contact.phones.first.id
        expect(json_response[:relationships][:phones].length).to eq contact.phones.length
        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroy a contact' do
      contact = create(:contact)

      delete "/contacts/#{contact.id}"

      expect(response).to have_http_status :no_content
    end
  end
end
