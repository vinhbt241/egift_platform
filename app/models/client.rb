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
class Client < ApplicationRecord
  # constants
  IDENTIFIER_DEFAULT_LENGTH = 50
  JWT_TOKEN_DURATION = 3.hours

  # attributes
  has_secure_password

  # validations
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :payout_rate, presence: true, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100.0 }
  validates :identifier, uniqueness: true

  # assocations
  belongs_to :user
  has_many :product_accesses, dependent: :destroy
  has_many :products, through: :product_accesses
  has_many :cards, dependent: :destroy
  has_many :card_activities, through: :cards

  # callback
  before_validation :generate_identifier, if: -> { identifier.blank? }

  def jwt_token
    JwtToken.encode(client_id: id, expired_at: DateTime.current + JWT_TOKEN_DURATION)
  end

  def generate_identifier
    loop do
      self.identifier = SecureRandom.alphanumeric(IDENTIFIER_DEFAULT_LENGTH)

      break unless Client.exists?(identifier: identifier)
    end
  end
end
