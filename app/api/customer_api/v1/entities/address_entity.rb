module CustomerAPI
  module V1
    module Entities
      class AddressEntity < Grape::Entity
        expose :id, documentation: { type: 'Integer', desc: 'Address unique ID' }
        expose :line1, documentation: { type: 'String', desc: 'Address line 1' }
        expose :line2, documentation: { type: 'String', desc: 'Address line 2' }
        expose :city, documentation: { type: 'String', desc: 'Address city' }
        expose :state, documentation: { type: 'String', desc: 'Address state' }
        expose :zip, documentation: { type: 'String', desc: 'Address zip code' }
        expose :customer_id, documentation: { type: 'Integer', desc: 'Customer ID' }
      end
    end
  end
end
