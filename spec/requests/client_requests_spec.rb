# frozen_string_literal: true

require 'swagger_helper'

describe 'User APIs' do
  path '/api/v1/clients' do
    get 'get all clients associate with current user' do
      tags 'Clients'
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

    post 'Create client' do
      tags 'Clients'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          client: {
            type: :object,
            properties: {
              name: { type: :string },
              password: { type: :string },
              payout_rate: { type: :decimal, example: 75.0 }
            },
            required: %w[name password payout_rate]
          }
        },
        required: ['client']
      }
      security [bearer_auth: {}]

      response '201', 'client created' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:params) { { client: { name: 'Foo', password: '123456', payout_rate: 50.0 } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:params) { { client: { name: 'Foo', password: '123456', payout_rate: 50.0 } } }

        run_test!
      end

      response '422', 'invalid record' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:params) { { client: { name: 'Foo', password: '123456', payout_rate: 150.0 } } }

        run_test!
      end
    end
  end

  path '/api/v1/clients/{id}' do
    put 'Update client' do
      tags 'Clients'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          client: {
            type: :object,
            properties: {
              name: { type: :string },
              password: { type: :string },
              payout_rate: { type: :decimal, example: 75.0 }
            }
          }
        },
        required: ['client']
      }
      security [bearer_auth: {}]

      response '200', 'client created' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:client) { create(:client, user:) }
        let(:id) { client.id }
        let(:params) { { client: { name: 'Foo', password: '123456', payout_rate: 50.0 } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:id) { 'client_id' }
        let(:params) { { client: { name: 'Foo', password: '123456', payout_rate: 50.0 } } }

        run_test!
      end

      response '422', 'invalid record' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:client) { create(:client, user:) }
        let(:id) { client.id }
        let(:params) { { client: { name: 'Foo', password: '123456', payout_rate: 150.0 } } }

        run_test!
      end
    end
  end
end
