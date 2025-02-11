# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id              :uuid             not null, primary key
#  identifier      :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  payout_rate     :decimal(5, 2)    default(100.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :uuid
#
# Indexes
#
#  index_clients_on_identifier        (identifier) UNIQUE
#  index_clients_on_name_and_user_id  (name,user_id) UNIQUE
#  index_clients_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'attributes' do
    it { is_expected.to have_secure_password }
  end

  describe 'validations' do
    subject { create(:client) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
    it { is_expected.to validate_uniqueness_of(:identifier) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:products) }
    it { is_expected.to have_many(:cards) }
    it { is_expected.to have_many(:card_activities) }
  end

  describe 'callbacks' do
    context 'when prepare to validate' do
      let(:client) { create(:client, identifier: nil) }

      it 'generate identifier if missing' do
        expect(client.identifier).to be_truthy
      end
    end
  end

  describe '#jwt_token' do
    let(:client) { create(:client) }

    it 'calls JwtToken.encode with correct payload', :aggregate_failures do
      expected_payload = { client_id: client.id, expired_at: DateTime.current + Client::JWT_TOKEN_DURATION }

      allow(JwtToken).to receive(:encode).with(hash_including(expected_payload)).and_return('jwt_token')

      token = client.jwt_token

      expect(token).to eq('jwt_token')
    end

    it 'returns a valid JWT token', :aggregate_failures do
      token = client.jwt_token
      decoded_payload = JwtToken.decode(token)

      expect(decoded_payload['client_id']).to eq(client.id)
      expect(DateTime.parse(decoded_payload['expired_at'])).to be_within(1.minute).of(
        DateTime.current + Client::JWT_TOKEN_DURATION
      )
    end
  end
end
