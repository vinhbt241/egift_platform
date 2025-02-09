# frozen_string_literal: true

module API
  module V1
    class ProductAccessesController < BaseController
      before_action :authenticate_request!

      def create
        success = ActiveRecord::Base.transaction do
          product_ids&.each do |product_id|
            ProductAccess.create!(product_id:, client_id:)
          end
        end

        unless success
          render_api_error(APIError::RecordInvalidError.new('client_id or product_ids is outside of user scope'))
          return
        end

        head :created
      end

      def destroy
        ActiveRecord::Base.transaction do
          product_ids&.each do |product_id|
            product_access = ProductAccess.find_by(product_id:, client_id:)
            next if product_access.blank?

            product_access.destroy!
          end
        end

        head :no_content
      end

      private

      def product_access_params
        params.require(:product_access).permit(
          [
            :client_id,
            { product_ids: [] }
          ]
        )
      end

      def product_ids
        product_access_params[:product_ids]
      end

      def client_id
        product_access_params[:client_id]
      end
    end
  end
end
