# frozen_string_literal: true

require 'swagger_helper'

describe 'User APIs' do
  path '/api/v1/users' do
    post 'Create new user (signup)' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        },
        required: ['user']
      }

      response '201', 'user created' do
        let(:params) { { user: { email: 'example_email@gmail.com', password: '123456' } } }

        run_test!
      end

      response '422', 'user already existed' do
        let(:params) { { user: { email: 'example_email@gmail.com', password: '123456' } } }

        before { create(:user, email: 'example_email@gmail.com') }

        run_test!
      end
    end
  end

  path '/api/v1/users/me' do
    get 'Get user profile' do
      tags 'Users'
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
  end
end
