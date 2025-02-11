# frozen_string_literal: true

require 'swagger_helper'

describe 'Client Session APIs' do
  path '/api/v1/clients/sessions' do
    post 'Create a client session (login)' do
      tags 'Client/Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          session: {
            type: :object,
            properties: {
              identifier: { type: :string }
            },
            required: %w[identifier]
          }
        },
        required: ['session']
      }

      response '201', 'session created' do
        let!(:client) { create(:client) }
        let(:params) { { session: { identifier: client.identifier, password: '12345' } } }

        run_test!
      end

      response '404', 'client not found' do
        let(:params) { { session: { identifier: 'invalid_identifier' } } }

        run_test!
      end
    end
  end
end
