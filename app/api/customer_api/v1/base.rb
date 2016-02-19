require 'grape-swagger'

module CustomerAPI
  module V1
    class Base < Grape::API
      prefix 'api'
      version 'v1', using: :path

      mount Customers
      mount Addresses

      add_swagger_documentation hide_documentation_path: true,
	api_version: 'v1'
    end
  end
end
