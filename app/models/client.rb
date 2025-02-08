# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id              :uuid             not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  payout_rate     :decimal(5, 2)    default(100.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :uuid
#
# Indexes
#
#  index_clients_on_name_and_user_id  (name,user_id) UNIQUE
#  index_clients_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Client < ApplicationRecord
  # attributes
  has_secure_password

  # validations
  validates :name, presence: true, uniqueness: { scope: :user_id }

  # assocations
  belongs_to :user

  def jwt_token
    JwtToken.encode(client_id: id)
  end
end
