# frozen_string_literal: true

require 'swagger_helper'

describe 'Brand APIs' do
  path '/api/v1/brands' do
    get 'get all brands created by current user' do
      tags 'Brands'
      produces 'application/json'
      security [bearer_auth: {}]

      response '200', 'success' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}

        run_test!
      end
    end

    post 'create brand' do
      tags 'Brands'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          brand: {
            type: :object,
            properties: {
              name: { type: :string },
              state: { type: :string, enum: Brand.states.keys },
              fields_attributes: {
                type: :object,
                properties: {
                  id: { type: :string },
                  name: { type: :string },
                  data: { type: :string },
                  field_type_id: { type: :string },
                  _destroy: { type: :boolean }
                },
                required: ['name']
              }
            },
            required: ['name']
          }
        },
        required: ['brand']
      }
      security [bearer_auth: {}]

      response '201', 'brand created' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:params) { { brand: { name: 'Razor' } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:params) { { brand: { name: 'Razor' } } }

        run_test!
      end

      response '422', 'record invalid' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:params) { { brand: { name: 'Razor' } } }

        before do
          create(:brand, name: 'Razor', user:)
        end

        run_test!
      end
    end
  end

  path '/api/v1/brands/{id}' do
    put 'update brand' do
      tags 'Brands'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          brand: {
            type: :object,
            properties: {
              name: { type: :string },
              state: { type: :string, enum: Brand.states.keys },
              fields_attributes: {
                type: :object,
                properties: {
                  id: { type: :string },
                  name: { type: :string },
                  data: { type: :string },
                  field_type_id: { type: :string },
                  _destroy: { type: :boolean }
                }
              }
            }
          }
        },
        required: ['brand']
      }
      security [bearer_auth: {}]

      response '200', 'brand edited' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:id) { brand.id }
        let(:params) { { brand: { state: 'archived' } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:id) { 'brand_id' }
        let(:params) { { brand: { state: 'archived' } } }

        run_test!
      end

      response '422', 'record invalid' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:brand) { create(:brand, user:) }
        let(:id) { brand.id }
        let(:params) { { brand: { name: nil } } }

        run_test!
      end
    end
  end
end
