# frozen_string_literal: true

module API
  module V1
    class BrandsController < BaseController
      before_action :authenticate_request!

      def index
        render_resource_collection(current_user.brands)
      end

      def create
        brand = current_user.brands.build(brand_params)

        if brand.save
          head :created
        else
          render_resource_errors(errors: brand.errors)
        end
      end

      def update
        brand = current_user.brands.find(params[:id])

        if brand.update(brand_params)
          head :ok
          return
        end

        render_resource_errors(errors: brand.errors)
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
