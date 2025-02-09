# frozen_string_literal: true

require 'swagger_helper'

describe 'Client Cards APIs' do
  path '/api/v1/card_activities' do
    post 'Retrieve a report of card activities for current user base on filters' do
      tags 'Card Activities (Report)'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          card_activity: {
            type: :object,
            properties: {
              filters: {
                type: :object,
                properties: {
                  card_id: { type: :string },
                  product_id: { type: :string },
                  brand_id: { type: :string },
                  client_id: { type: :string },
                  name: { type: :string },
                  from_datetime: { type: :datime }
                }
              }
            }
          }
        }
      }
      security [bearer_auth: {}]

      response '200', 'success' do
        let!(:user) { create(:user) }
        let(:Authorization) { "Bearer #{user.jwt_token}" }
        let(:params) { { card_activity: { filters: {} } } }

        run_test!
      end

      response '401', 'not authenticated' do
        let(:Authorization) {}
        let(:params) { { card_activity: { filters: {} } } }

        run_test!
      end
    end
  end
end
