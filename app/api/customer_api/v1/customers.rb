module CustomerAPI
  module V1
    class Customers < Grape::API
      ENTITY = Entities::CustomerEntity

      resource :customers do
        desc 'Return a list of customers'
        get do
          present Customer.with_addresses, with: ENTITY
        end

        desc 'Return customer by id'
        get ':id' do
          present Customer.find(params[:id]), with: ENTITY
        end

        desc 'Create a new customer'
        params do
          requires :name, type: String
          requires :email, type: String
          requires :dob, type: Date
          requires :phone, type: String
        end
        post do
          customer_params = authorize_params(params, :name, :email, :dob, :phone)
          customer = Customer.new(customer_params)

          if customer.save
            present customer, with: ENTITY
          else
            msg = customer.errors.full_messages.join(', ').downcase
            error!({message: "Validation error: #{msg}", status: 400}, 400)
          end
        end

        desc 'Update existing customer'
        params do
          optional :name, type: String
          optional :email, type: String
          optional :dob, type: Date
          optional :phone, type: String
        end
        put ':id' do
          customer = Customer.find(params[:id])

          params.delete(:id)
          customer_params = authorize_params(params, :name, :email, :dob, :phone)

          if customer.update_attributes(customer_params)
            present customer, with: ENTITY
          else
            msg = customer.errors.full_messages.join(', ').downcase
            error!({message: "Validation error: #{msg}", status: 400}, 400)
          end
        end

        desc 'Delete existing customer'
        delete ':id' do
          present Customer.destroy(params[:id]), with: ENTITY
        end
      end

    end
  end
end
