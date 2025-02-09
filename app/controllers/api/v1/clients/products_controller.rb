# frozen_string_literal: true

module API
  module V1
    module Clients
      class ProductsController < BaseController
        before_action :authenticate_client!

        def index
          render_resource_collection(current_client.products.viewable)
        end
      end
    end
  end
end
