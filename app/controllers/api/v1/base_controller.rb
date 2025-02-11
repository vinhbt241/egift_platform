# frozen_string_literal: true

require 'jwt_token'

module API
  module V1
    class BaseController < ApplicationController
      def authenticate_request!
        return if current_user.present?

        render_api_error(APIError::NotAuthenticatedError.new)
      end

      def current_user
        return if decoded_token.blank?

        expired_at = decoded_token['expired_at']
        return if expired_at.blank? || DateTime.current > expired_at.to_datetime

        user_id = decoded_token['user_id']
        User.find_by(id: user_id)
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
