# frozen_string_literal: true

require 'swagger_helper'

describe 'Client Cards APIs' do
  path '/api/v1/clients/cards' do
    get "Retrieve list of client's cards" do
      tags 'Client/Cards'
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

    post 'Request a new card' do
      tags 'Client/Cards'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          card: {
            type: :object,
            properties: {
              product_id: { type: :string },
              activation_number: { type: :string },
              pin_number: { type: :string }
            },
            required: %w[product_id]
          }
        },
        required: ['card']
      }
      security [bearer_auth: {}]

      response '201', 'card issued' do
        let!(:client) { create(:client) }
        let(:Authorization) { "Bearer #{client.jwt_token}" }
        let(:brand) { create(:brand, user: client.user) }
        let(:product) { create(:product, brand:) }
        let(:params) { { card: { product_id: product.id } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:params) { { card: { product_id: 'product_id' } } }

        run_test!
      end

      response '422', 'record invalid' do
        let!(:client) { create(:client) }
        let(:Authorization) { "Bearer #{client.jwt_token}" }
        let(:params) { { card: { product_id: 'product_id' } } }

        run_test!
      end
    end
  end

  path '/api/v1/clients/cards/activate' do
    put 'Activate card' do
      tags 'Client/Cards'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          card: {
            type: :object,
            properties: {
              activation_number: { type: :string },
              pin_number: { type: :string }
            },
            required: %w[activation_number]
          }
        },
        required: ['card']
      }
      security [bearer_auth: {}]

      response '200', 'card activated' do
        let!(:card) { create(:card) }
        let(:client) { card.client }
        let(:Authorization) { "Bearer #{client.jwt_token}" }
        let(:params) { { card: { activation_number: card.activation_number } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:params) { { card: { activation_number: 'activation_number' } } }

        run_test!
      end

      response '422', 'card can not be activated' do
        let!(:card) { create(:card, status: :canceled) }
        let(:client) { card.client }
        let(:Authorization) { "Bearer #{client.jwt_token}" }
        let(:params) { { card: { activation_number: card.activation_number } } }

        run_test!
      end
    end
  end

  path '/api/v1/clients/cards/redeem' do
    put 'Redeem card' do
      tags 'Client/Cards'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          card: {
            type: :object,
            properties: {
              activation_number: { type: :string },
              pin_number: { type: :string }
            },
            required: %w[activation_number]
          }
        },
        required: ['card']
      }
      security [bearer_auth: {}]

      response '200', 'card redeemed' do
        let!(:card) { create(:card, status: :active) }
        let(:client) { card.client }
        let(:Authorization) { "Bearer #{client.jwt_token}" }
        let(:params) { { card: { activation_number: card.activation_number } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:params) { { card: { activation_number: 'activation_number' } } }

        run_test!
      end

      response '422', 'card can not be redeemed' do
        let!(:card) { create(:card, status: :created) }
        let(:client) { card.client }
        let(:Authorization) { "Bearer #{client.jwt_token}" }
        let(:params) { { card: { activation_number: card.activation_number } } }

        run_test!
      end
    end
  end

  path '/api/v1/clients/cards/cancel' do
    put 'Cancel card' do
      tags 'Client/Cards'
      consumes 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          card: {
            type: :object,
            properties: {
              activation_number: { type: :string },
              pin_number: { type: :string }
            },
            required: %w[activation_number]
          }
        },
        required: ['card']
      }
      security [bearer_auth: {}]

      response '200', 'card canceled' do
        let!(:card) { create(:card) }
        let(:client) { card.client }
        let(:Authorization) { "Bearer #{client.jwt_token}" }
        let(:params) { { card: { activation_number: card.activation_number } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:params) { { card: { activation_number: 'activation_number' } } }

        run_test!
      end

      response '422', 'card can not be canceled' do
        let!(:card) { create(:card) }
        let(:client) { card.client }
        let(:Authorization) { "Bearer #{client.jwt_token}" }
        let(:params) { { card: { activation_number: card.activation_number } } }

        before do
          card.active!
          card.redeemed!
        end

        run_test!
      end
    end
  end
end
