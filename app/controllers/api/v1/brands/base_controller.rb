# frozen_string_literal: true

module API
  module V1
    module Brands
      class BaseController < API::V1::BaseController
        before_action :authenticate_request!
        before_action :prepare_brand

        def prepare_brand
          @brand = current_user.brands.find(params[:brand_id])
        end
      end
    end
  end
end
