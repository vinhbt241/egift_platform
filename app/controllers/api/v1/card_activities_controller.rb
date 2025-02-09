# frozen_string_literal: true

module API
  module V1
    class CardActivitiesController < BaseController
      before_action :authenticate_request!

      def create
        card_activities = CardActivityQuery.call(
          scope: CardActivity.all,
          filters: card_activity_params[:filters].to_h.merge({ user_id: current_user.id })
        )

        render_resource_collection(card_activities, each_serializer: ActivitySerializer)
      end

      def card_activity_params
        params.require(:card_activity).permit(
          [
            filters: %i[
              card_id
              product_id
              brand_id
              client_id
              name
              from_datetime
            ]
          ]
        )
      end
    end
  end
end
