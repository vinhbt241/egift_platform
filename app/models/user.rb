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
  has_secure_password

  validates :email, presence: true, uniqueness: true

  def jwt_token
    JwtToken.encode(user_id: id)
  end
end
