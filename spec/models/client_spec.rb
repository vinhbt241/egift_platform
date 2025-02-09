# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id          :uuid             not null, primary key
#  identifier  :string           not null
#  name        :string           not null
#  payout_rate :decimal(5, 2)    default(100.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid
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

    it 'return encoded jwt token contains client id' do
      jwt_token = JwtToken.encode(client_id: client.id)

      expect(jwt_token).to eq(client.jwt_token)
    end
  end
end
