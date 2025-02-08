# frozen_string_literal: true

module API
  module V1
    module Clients
      class SessionsController < BaseController
        def create
          client = Client.find_by(identifier: session_params[:identifier])

          if client.present?
            render_resource(client, view: :with_token, status: :created)
          else
            render_api_error(APIError::NotFoundError.new)
          end
        end

        private

        def session_params
          params.require(:session).permit(:identifier)
        end
      end
    end
  end
end
