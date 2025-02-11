# frozen_string_literal: true

module API
  module V1
    module Clients
      class SessionsController < BaseController
        def create
          client = Client.find_by!(identifier: session_params[:identifier])

          if client.authenticate(session_params[:password])
            render_resource(client, view: :with_token, status: :created)
          else
            render_api_error(APIError::NotFoundError.new)
          end
        end

        private

        def session_params
          params.require(:session).permit(
            %i[
              identifier
              password
            ]
          )
        end
      end
    end
  end
end
