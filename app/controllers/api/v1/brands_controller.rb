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

      private

      def brand_params
        params.require(:brand).permit(
          [
            :name,
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
