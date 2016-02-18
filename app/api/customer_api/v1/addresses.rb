module CustomerAPI
  module V1
    class Addresses < Grape::API
      ENTITY = Entities::AddressEntity

      namespace :customers do
        route_param :customer_id do
          resource :addresses do
            desc 'Return a list of addresses' do
              success ENTITY
              failure [
                [404, 'Not Found'],
                [500, 'Internal Server Error']
              ]
            end
            get do
              present Customer.find(params[:customer_id]).addresses, with: ENTITY
            end

            desc 'Return address by id' do
              success ENTITY
              failure [
                [404, 'Not Found'],
                [500, 'Internal Server Error']
              ]
            end
            get ':id' do
              present Address.find_by!(id: params[:id], customer_id: params[:customer_id]), with: ENTITY
            end

            desc 'Create a new address' do
              success ENTITY
              failure [
                [400, 'Bad Request'],
                [404, 'Not Found'],
                [500, 'Internal Server Error']
              ]
            end
            params do
              requires :line1, type: String
              optional :line2, type: String
              requires :city, type: String
              requires :state, type: String
              requires :zip, type: String
            end
            post do
              raise ActiveRecord::RecordNotFound unless Customer.exists?(params[:customer_id])

              address_params = authorize_params(params, :line1, :line2, :city, :state, :zip, :customer_id)
              address = Address.new(address_params)

              if address.save
                present address, with: ENTITY
              else
                msg = address.errors.full_messages.join(', ').downcase
                error!({message: "Validation error: #{msg}", status: 400}, 400)
              end
            end

            desc 'Update existing address' do
              success ENTITY 
              failure [
                [400, 'Bad Request'],
                [404, 'Not Found'],
                [500, 'Internal Server Error']
              ]
            end
            params do
              optional :line1, type: String
              optional :line2, type: String
              optional :city, type: String
              optional :state, type: String
              optional :zip, type: String
            end
            put ':id' do
              address = Address.find_by!(id: params[:id], customer_id: params[:customer_id])

              params.delete(:id)
              params.delete(:customer_id)
              address_params = authorize_params(params, :line1, :line2, :city, :state, :zip)

              if address.update_attributes(address_params)
                present address, with: ENTITY
              else
                msg = address.errors.full_messages.join(', ').downcase
                error!({message: "Validation error: #{msg}", status: 400}, 400)
              end
            end

            desc 'Delete existing address' do
              success ENTITY
              failure [
                [404, 'Not Found']
              ]
            end
            delete ':id' do
              present Address.find_by!(id: params[:id], customer_id: params[:customer_id]).destroy!, with: ENTITY
            end
          end
        end
      end
    end
  end
end
