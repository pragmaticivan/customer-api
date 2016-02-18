class API < Grape::API
  format :json

  rescue_from ActiveRecord::RecordNotFound do |e|
    rack_response({status: 404, message: 'Not Found'}.to_json, 404)
  end
  rescue_from Grape::Exceptions::ValidationErrors do |e|
    rack_response({status: 400, message: "Validation error: #{e.message}"}.to_json, 400)
  end
  rescue_from :all do |e|
    Rails.logger.error(e)
    Rails.logger.error(e.backtrace.join("\n"))
    rack_response({status: 500, message: 'Internal Server Error'}.to_json, 500)
  end

  helpers do
    def authorize_params(params, *permitted)
      ActionController::Parameters.new(params).permit(*permitted)
    end
  end

  mount CustomerAPI::V1::Base
end
