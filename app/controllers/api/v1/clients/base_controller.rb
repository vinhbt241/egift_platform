# frozen_string_literal: true

require 'jwt_token'

module API
  module V1
    module Clients
      class BaseController < ApplicationController
        def authenticate_client!
          return if current_client.present?

          render_api_error(APIError::NotAuthenticatedError.new)
        end

        def current_client
          return if decoded_token.blank?

          client_id = decoded_token['client_id']
          Client.find_by(id: client_id)
        end

        def decoded_token
          header = request.headers['Authorization']
          return if header.blank?

          token = header.split(' ')[1]

          JwtToken.decode(token)
        end
      end
    end
  end
end
