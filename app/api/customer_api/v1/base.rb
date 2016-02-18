module CustomerAPI
  module V1
    class Base < Grape::API
      prefix 'api'
      version 'v1', using: :path

      mount Customers
    end
  end
end
