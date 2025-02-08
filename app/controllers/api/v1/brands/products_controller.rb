# frozen_string_literal: true

module API
  module V1
    module Brands
      class ProductsController < BaseController
        def index
          render_resource_collection(@brand.products)
        end

        def create
          product = @brand.products.build(product_params)

          if product.save
            head :created
          else
            render_resource_errors(errors: product.errors)
          end
        end

        private

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
end
