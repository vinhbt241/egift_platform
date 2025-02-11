# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'
require 'jwt_token'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  describe 'attributes' do
    it { is_expected.to have_secure_password }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:brands) }
    it { is_expected.to have_many(:products) }
    it { is_expected.to have_many(:clients) }
    it { is_expected.to have_many(:card_activities) }
  end

  describe '#jwt_token' do
    it 'calls JwtToken.encode with correct payload', :aggregate_failures do
      expected_payload = { user_id: user.id, expired_at: DateTime.current + User::JWT_TOKEN_DURATION }

      allow(JwtToken).to receive(:encode).with(hash_including(expected_payload)).and_return('jwt_token')

      token = user.jwt_token

      expect(token).to eq('jwt_token')
    end

    it 'returns a valid JWT token', :aggregate_failures do
      token = user.jwt_token
      decoded_payload = JwtToken.decode(token)

      expect(decoded_payload['user_id']).to eq(user.id)
      expect(DateTime.parse(decoded_payload['expired_at'])).to be_within(1.minute).of(
        DateTime.current + User::JWT_TOKEN_DURATION
      )
    end
  end
end
