# frozen_string_literal: true

require 'swagger_helper'

describe 'Product Access APIs' do
  path '/api/v1/product_accesses' do
    post 'Create product accesses for a client' do
      tags 'Product Accesses'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          product_access: {
            type: :object,
            properties: {
              client_id: { type: :string },
              product_ids: { type: :array, items: { type: :string } }
            },
            required: %w[client_id product_ids]
          }
        },
        required: ['product_access']
      }
      security [bearer_auth: {}]

      response '201', 'product access created' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:product) { create(:product, brand:) }
        let(:client) { create(:client, user:) }
        let(:params) { { product_access: { client_id: client.id, product_ids: [product.id] } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:params) { { product_access: { client_id: 'client_id', product_ids: %w[product_id_1 product_id_2] } } }

        run_test!
      end

      response '422', 'record invalid' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:product) { create(:product, brand:) }
        let(:client) { create(:client) }
        let(:params) { { product_access: { client_id: client.id, product_ids: [product.id] } } }

        run_test!
      end
    end

    delete 'Remove product accesses from a client' do
      tags 'Product Accesses'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          product_access: {
            type: :object,
            properties: {
              client_id: { type: :string },
              product_ids: { type: :array, items: { type: :string } }
            },
            required: %w[client_id product_ids]
          }
        },
        required: ['product_access']
      }
      security [bearer_auth: {}]

      response '204', 'product accesses removed' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:product) { create(:product, brand:) }
        let(:client) { create(:client, user:) }
        let(:params) { { product_access: { client_id: client.id, product_ids: [product.id] } } }

        before do
          ProductAccess.create!(product:, client:)
        end

        run_test! do
          expect(ProductAccess.count).to eq(0)
        end
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:params) { { product_access: { client_id: 'client_id', product_ids: %w[product_id_1 product_id_2] } } }

        run_test!
      end
    end
  end
end
