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

require 'jwt_token'

class User < ApplicationRecord
  # constants
  JWT_TOKEN_DURATION = 3.hours

  # attributes
  has_secure_password

  # validations
  validates :email, presence: true, uniqueness: true

  # associations
  has_many :brands, dependent: :destroy
  has_many :products, through: :brands
  has_many :clients, dependent: :destroy
  has_many :card_activities, through: :clients

  def jwt_token
    JwtToken.encode(user_id: id, expired_at: DateTime.current + JWT_TOKEN_DURATION)
  end
end
