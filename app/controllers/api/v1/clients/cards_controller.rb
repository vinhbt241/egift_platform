# frozen_string_literal: true

module API
  module V1
    module Clients
      class CardsController < BaseController
        before_action :authenticate_client!
        before_action :prepare_card, only: %i[activate redeem cancel]

        def index
          render_resource_collection(current_client.cards)
        end

        def create
          card = current_client.cards.create!(card_params)

          render_resource(card, view: :with_credentials, status: :created)
        end

        def activate
          @card.active!

          head :ok
        end

        def redeem
          @card.redeemed!

          head :ok
        end

        def cancel
          @card.canceled!

          head :ok
        end

        private

        def card_params
          params.require(:card).permit(
            %i[
              product_id
              activation_number
              pin_number
            ]
          )
        end

        def prepare_card
          @card = current_client.cards.by_credentials(
            card_params[:activation_number],
            card_params[:pin_number]
          ).first
        end
      end
    end
  end
end
