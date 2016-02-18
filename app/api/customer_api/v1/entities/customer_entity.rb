module CustomerAPI
  module V1
    module Entities
      class CustomerEntity < Grape::Entity
        expose :id, documentation: { type: 'Integer', desc: "Customer's unique ID" }
        expose :name, documentation: { type: 'String', desc: "Customer's name" }
        expose :email, documentation: { type: 'String', desc: "Customer's email" }
        expose :dob, documentation: { type: 'Date', desc: "Customer's date of birth" }
        expose :phone, documentation: { type: 'String', desc: "Customer's phone number" }
        expose :addresses, using: AddressEntity
      end
    end
  end
end
