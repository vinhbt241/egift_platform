# frozen_string_literal: true

module API
  module V1
    class ClientsController < BaseController
      before_action :authenticate_request!
      before_action :prepare_client, only: %i[show update]

      def index
        render_resource_collection(current_user.clients)
      end

      def create
        client = current_user.clients.create!(client_params)

        render_resource(client, status: :created)
      end

      def show
        render_resource(@client)
      end

      def update
        @client.update!(client_params)

        head :ok
      end

      private

      def client_params
        params.require(:client).permit(
          %i[
            name
            password
            payout_rate
          ]
        )
      end

      def prepare_client
        @client = current_user.clients.find(params[:id])
      end
    end
  end
end
