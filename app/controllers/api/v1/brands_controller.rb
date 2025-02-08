# frozen_string_literal: true

module API
  module V1
    class BrandsController < BaseController
      before_action :authenticate_request!

      def index
        render_resource_collection(current_user.brands)
      end

      def create
        current_user.brands.create!(brand_params)

        head :created
      end

      def update
        brand = current_user.brands.find(params[:id])
        brand.update!(brand_params)

        head :ok
      end

      private

      def brand_params
        params.require(:brand).permit(
          [
            :name,
            :state,
            {
              fields_attributes: %i[
                id
                name
                data
                field_type_id
                _destroy
              ]
            }
          ]
        )
      end
    end
  end
end
