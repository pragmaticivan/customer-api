require 'rails_helper'

describe CustomerAPI::V1 do
  describe 'Addresses' do
    before do
      create(:customer, id: 1)
    end

    describe 'GET /api/v1/customers/:customer_id/addresses' do
      it 'returns an empty list if no addresses exist for the customer' do
        get '/api/v1/customers/1/addresses'

        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(json_body.size).to eq(0)
      end

      it 'returns a list with all addresses for the customer' do
        addresses = create_list(:address, 3, customer_id: 1)

        get '/api/v1/customers/1/addresses'

        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(json_body.size).to eq(3)
      end

      it 'returns an error when customer is not found' do
        get '/api/v1/customers/1234/addresses'

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end
    end

    describe 'GET /api/v1/customers/:customer_id/addresses/:id' do
      let!(:address) { create(:address, id: 1, line1: '123 Foo Street', customer_id: 1) }

      it 'returns address by id' do
        get '/api/v1/customers/1/addresses/1'

        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(json_body).to have_json_attributes_and_values(id: 1, line1: '123 Foo Street')
        expect(json_body.keys).to contain_exactly(*%w(id line1 line2 city state zip customer_id))
      end

      it 'returns error when customer is not found' do
        get '/api/v1/customers/1234/addresses/1'

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end

      it 'returns error when address is not found' do
        get '/api/v1/customers/1/addresses/1234'

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end
    end

    describe 'POST /api/v1/customers/:customer_id/addresses' do
      let(:valid_params) do
        {
          line1: '123 Foo Street',
          city: 'Bar',
          state: 'Baz',
          zip: '90210'
        }
      end
      let(:invalid_params) { valid_params.merge({line1: ''}) }

      it 'creates a new address with valid params' do
        expect {
          post '/api/v1/customers/1/addresses', valid_params
        }.to change(Address, :count).by(1)

        expect(response).to be_success
        expect(response).to have_http_status(201)
        expect(json_body).to have_json_attributes_and_values(valid_params)
        expect(json_body.keys).to contain_exactly(*%w(id line1 line2 city state zip customer_id))
      end

      it 'returns error if params are missing' do
        expect {
          post '/api/v1/customers/1/addresses'
        }.not_to change(Address, :count)

        expect(response).not_to be_success
        expect(response).to have_http_status(400)
        expect(json_body).to have_json_attributes_and_values(status: 400, message: /^validation error/i)
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end

      it 'returns error if params are invalid' do
        expect {
          post '/api/v1/customers/1/addresses', invalid_params
        }.not_to change(Address, :count)

        expect(response).not_to be_success
        expect(response).to have_http_status(400)
        expect(json_body).to have_json_attributes_and_values(status: 400, message: /^validation error/i)
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end

      it 'returns error when customer is not found' do
        expect {
          post '/api/v1/customers/1234/addresses', valid_params
        }.not_to change(Address, :count)

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end
    end

    describe 'PUT /api/v1/customers/:customer_id/addresses/:id' do
      let!(:address) { create(:address, id: 1, line1: '123 Foo Street', state: 'Baz', customer_id: 1) }

      it 'updates an existing address with valid params' do
        put '/api/v1/customers/1/addresses/1', { line1: '123 Foo Avenue' }

        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(json_body).to have_json_attributes_and_values(id: 1, line1: '123 Foo Avenue', state: 'Baz')
        expect(json_body.keys).to contain_exactly(*%w(id line1 line2 city state zip customer_id))
      end

      it 'returns error if address is not found' do
        put '/api/v1/customers/1/addresses/1234', { line1: '123 Foo Avenue' }

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end

      it 'returns error if customer is not found' do
        put '/api/v1/customers/1234/addresses/1', { line1: '123 Foo Avenue' }

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end

      it 'returns error if params are invalid' do
        put '/api/v1/customers/1/addresses/1', { line1: '' }

        expect(response).not_to be_success
        expect(response).to have_http_status(400)
        expect(json_body).to have_json_attributes_and_values(status: 400, message: /^validation error/i)
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end
    end

    describe 'DELETE /api/v1/customers/:customer_id/addresses/:id' do
      let!(:address) { create(:address, id: 1, line1: '123 Foo Street', customer_id: 1) }

      it 'delete an existing address' do
        expect {
          delete '/api/v1/customers/1/addresses/1'
        }.to change(Address, :count).by(-1)

        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(json_body).to have_json_attributes_and_values(id: 1)
        expect(json_body.keys).to contain_exactly(*%w(id line1 line2 city state zip customer_id))
      end

      it 'returns error if address is not found' do
        expect {
          delete '/api/v1/customers/1/addresses/1234'
        }.not_to change(Address, :count)

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end

      it 'returns error if customer is not found' do
        expect {
          delete '/api/v1/customers/1234/addresses/1'
        }.not_to change(Address, :count)

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end
    end
  end
end
