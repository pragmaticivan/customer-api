require 'rails_helper'

describe CustomerAPI::V1 do
  describe 'Customers' do

    describe 'GET /api/v1/customers' do
      it 'returns an empty list if no customers exist' do
        get '/api/v1/customers'

        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(json_body.size).to eq(0)
      end

      it 'returns a list with all customers' do
        customers = create_list(:customer, 3)

        get '/api/v1/customers'

        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(json_body.size).to eq(3)
      end
    end

    describe 'GET /api/v1/customers/:id' do
      let!(:customer) { create(:customer, id: 1, name: 'John Doe') }

      it 'returns customer by id' do
        get '/api/v1/customers/1'

        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(json_body).to have_json_attributes_and_values(id: 1, name: 'John Doe')
        expect(json_body.keys).to contain_exactly(*%w(id name email dob phone addresses))
      end

      it 'returns error when user is not found' do
        get '/api/v1/customers/1234'

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end
    end

    describe 'POST /api/v1/customers' do
      let(:valid_params) do
        {
          name: 'John Doe',
          email: 'john.doe@example.com',
          dob: '1970-01-01',
          phone: '555-555-5555'
        }
      end
      let(:invalid_params) { valid_params.merge({dob: '', phone: ''}) }

      it 'creates a new customer with valid params' do
        expect {
          post '/api/v1/customers', valid_params
        }.to change(Customer, :count).by(1)

        expect(response).to be_success
        expect(response).to have_http_status(201)
        expect(json_body).to have_json_attributes_and_values(valid_params)
        expect(json_body.keys).to contain_exactly(*%w(id name email dob phone addresses))
      end

      it 'returns error if params are missing' do
        expect {
          post '/api/v1/customers', {}
        }.not_to change(Customer, :count)

        expect(response).not_to be_success
        expect(response).to have_http_status(400)
        expect(json_body).to have_json_attributes_and_values(status: 400, message: /^validation error/i)
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end

      it 'returns error if params are invalid' do
        expect {
          post '/api/v1/customers', invalid_params
        }.not_to change(Customer, :count)

        expect(response).not_to be_success
        expect(response).to have_http_status(400)
        expect(json_body).to have_json_attributes_and_values(status: 400, message: /^validation error/i)
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end
    end

    describe 'PUT /api/v1/customers/:id' do
      let!(:customer) { create(:customer, id: 1, name: 'John Doe', dob: '1970-01-01') }

      it 'updates an existing customer with valid params' do
        put '/api/v1/customers/1', { name: 'John Smith' }

        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(json_body).to have_json_attributes_and_values(id: 1, name: 'John Smith', dob: '1970-01-01')
        expect(json_body.keys).to contain_exactly(*%w(id name email dob phone addresses))
      end

      it 'returns error if customer is not found' do
        put '/api/v1/customers/1234', { name: 'John Smith' }

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end

      it 'returns error if params are invalid' do
        put '/api/v1/customers/1', { dob: 'this is not a date' }

        expect(response).not_to be_success
        expect(response).to have_http_status(400)
        expect(json_body).to have_json_attributes_and_values(status: 400, message: /^validation error/i)
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end
    end

    describe 'DELETE /api/v1/customers/:id' do
      let!(:customer) { create(:customer, id: 1) }

      it 'delete an existing customer' do
        expect {
          delete '/api/v1/customers/1'
        }.to change(Customer, :count).by(-1)

        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(json_body).to have_json_attributes_and_values(id: 1)
        expect(json_body.keys).to contain_exactly(*%w(id name email dob phone addresses))
      end

      it 'returns error if customer is not found' do
        expect {
          delete '/api/v1/customers/1234'
        }.not_to change(Customer, :count)

        expect(response).not_to be_success
        expect(response).to have_http_status(404)
        expect(json_body).to have_json_attributes_and_values(status: 404, message: 'Not Found')
        expect(json_body.keys).to contain_exactly(*%w(status message))
      end
    end
  end
end
