# frozen_string_literal: true

module API
  module V1
    class ProductsController < BaseController
      before_action :authenticate_request!
      before_action :prepare_product

      def show
        render_resource(@product)
      end

      def update
        if @product.update(product_params)
          head :ok
          return
        end

        render_resource_errors(errors: @product.errors)
      end

      def destroy
        @product.destroy!

        head :no_content
      end

      private

      def prepare_product
        @product = current_user.products.find(params[:id])
      end

      def product_params
        params.require(:product).permit(
          [
            :price,
            :currency,
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
