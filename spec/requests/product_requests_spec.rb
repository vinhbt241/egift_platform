# frozen_string_literal: true

require 'swagger_helper'

describe 'Products APIs' do
  path '/api/v1/brands/{brand_id}/products' do
    get 'Retrieve list of products by brand' do
      tags 'Products'
      produces 'application/json'
      parameter name: :brand_id, in: :path, type: :string
      security [bearer_auth: {}]

      response '200', 'success' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:brand_id) { brand.id }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:brand_id) { 'some_id' }

        run_test!
      end
    end

    post 'Create product' do
      tags 'Products'
      consumes 'application/json'
      parameter name: :brand_id, in: :path, type: :string
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              state: { type: :string, enum: Brand.states.keys },
              price: { type: :decimal, example: 100.055 },
              currency: { type: :string },
              fields_attributes: {
                type: :object,
                properties: {
                  id: { type: :string },
                  name: { type: :string },
                  data: { type: :text },
                  field_type_id: { type: :string },
                  _destroy: { type: :boolean }
                },
                required: ['name']
              }
            },
            required: %w[price currency]
          }
        },
        required: ['product']
      }
      security [bearer_auth: {}]

      response '201', 'product created' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:brand_id) { brand.id }
        let(:params) { { product: { price: 1.5, currency: 'usd' } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:brand_id) { 'brand_id' }
        let(:params) { { product: { price: 1.5, currency: 'usd' } } }

        run_test!
      end

      response '422', 'record invalid' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:brand_id) { brand.id }
        let(:params) { { product: { currency: 'invalid_currency' } } }

        run_test!
      end
    end
  end

  path '/api/v1/products/{id}' do
    get 'Retrieve a product' do
      tags 'Products'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      security [bearer_auth: {}]

      response '200', 'success' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:product) { create(:product, brand:) }
        let(:id) { product.id }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:id) { 'some_id' }

        run_test!
      end
    end

    put 'update a product' do
      tags 'Products'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              state: { type: :string, enum: Brand.states.keys },
              price: { type: :decimal, example: 100.055 },
              currency: { type: :string },
              fields_attributes: {
                type: :object,
                properties: {
                  id: { type: :string },
                  name: { type: :string },
                  data: { type: :text },
                  field_type_id: { type: :string },
                  _destroy: { type: :boolean }
                }
              }
            }
          }
        },
        required: ['product']
      }
      security [bearer_auth: {}]

      response '200', 'product edited' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:product) { create(:product, brand:) }
        let(:id) { product.id }
        let(:params) { { product: { price: 1.5, currency: 'usd' } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:id) { 'product_id' }
        let(:params) { { product: { price: 1.5, currency: 'usd' } } }

        run_test!
      end

      response '422', 'record invalid' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:product) { create(:product, brand:) }
        let(:id) { product.id }
        let(:params) { { product: { currency: 'invalid_currency' } } }

        run_test!
      end
    end

    delete 'remove product' do
      tags 'Products'
      parameter name: :id, in: :path, type: :string
      security [bearer_auth: {}]

      response '204', 'product removed' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:product) { create(:product, brand:) }
        let(:id) { product.id }

        run_test! do
          expect(Product.exists?(id: product.id)).to be false
        end
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:id) { 'product_id' }

        run_test!
      end
    end
  end
end
