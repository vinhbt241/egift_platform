# frozen_string_literal: true

module API
  module V1
    class ClientsController < BaseController
      before_action :authenticate_request!

      def index
        render_resource_collection(current_user.clients)
      end

      def create
        current_user.clients.create!(client_params)

        head :created
      end

      def update
        client = current_user.clients.find(params[:id])
        client.update!(client_params)

        head :ok
      end

      private

      def client_params
        params.require(:client).permit(:name, :password, :payout_rate)
      end
    end
  end
end
