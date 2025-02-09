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
    it 'return encoded jwt token contains user id' do
      jwt_token = JwtToken.encode(user_id: user.id)

      expect(jwt_token).to eq(user.jwt_token)
    end
  end
end
