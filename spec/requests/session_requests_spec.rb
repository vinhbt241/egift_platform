# frozen_string_literal: true

require 'swagger_helper'

describe 'Session APIs' do
  path '/api/v1/sessions' do
    post 'Create a session (login)' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          session: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        },
        required: ['session']
      }

      response '201', 'session created' do
        let!(:user) { create(:user, password: '123456') }
        let(:params) { { session: { email: user.email, password: '123456' } } }

        run_test!
      end

      response '404', 'invalid email or password' do
        let!(:user) { create(:user, password: '123456') }
        let(:params) { { session: { email: user.email, password: '123457' } } }

        run_test!
      end
    end
  end
end
