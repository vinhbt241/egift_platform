# frozen_string_literal: true

require 'swagger_helper'

describe 'Client Products APIs' do
  path '/api/v1/clients/products' do
    get 'Retrieve list of products client can access' do
      tags 'Client/Products'
      produces 'application/json'
      security [bearer_auth: {}]

      response '200', 'success' do
        let!(:client) { create(:client) }
        let(:Authorization) { "Bearer #{client.jwt_token}" }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}

        run_test!
      end
    end
  end
end
