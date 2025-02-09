# frozen_string_literal: true

# == Schema Information
#
# Table name: cards
#
#  id                :uuid             not null, primary key
#  activation_number :string           not null
#  pin_number        :string           not null
#  status            :integer          default("created")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  client_id         :uuid
#  product_id        :uuid
#
# Indexes
#
#  index_cards_on_client_id                         (client_id)
#  index_cards_on_pin_number_and_activation_number  (pin_number,activation_number) UNIQUE
#  index_cards_on_product_id                        (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (product_id => products.id)
#
class Card < ApplicationRecord
  # constants
  ACTIVATION_NUMBER_DEFAULT_LENGTH = 16
  PIN_NUMBER_DEFAULT_LENGTH = 8

  # attributes
  enum :status, { created: 0, active: 1, redeemed: 2, canceled: 3 }

  # validations
  validates :pin_number, uniqueness: { scope: :activation_number }
  validate :can_active
  validate :can_redeem
  validate :can_cancel

  # associations
  belongs_to :client
  belongs_to :product

  # callback
  before_validation :generate_activation_number, if: -> { activation_number.blank? }
  before_validation :generate_pin_number, if: -> { pin_number.blank? }

  # scopes
  scope :by_credentials, lambda { |an, pn|
    if pn.present?
      where(activation_number: an, pin_number: pn)
    else
      where(activation_number: an)
    end
  }

  def generate_activation_number
    loop do
      self.activation_number = SecureRandom.alphanumeric(ACTIVATION_NUMBER_DEFAULT_LENGTH)

      break unless Card.exists?(activation_number: activation_number)
    end
  end

  def generate_pin_number
    loop do
      self.pin_number = SecureRandom.alphanumeric(PIN_NUMBER_DEFAULT_LENGTH)

      break unless Card.exists?(activation_number: activation_number, pin_number: pin_number)
    end
  end

  def can_active
    return unless status_changed? && active? && (status_was != 'created')

    errors.add(:status, 'can not be activated')
  end

  def can_redeem
    return unless status_changed? && redeemed? && (status_was != 'active')

    errors.add(:status, 'can not be redeemed')
  end

  def can_cancel
    return unless status_changed? && canceled? && (status_was == 'redeemed')

    errors.add(:status, 'can not be canceled')
  end
end
