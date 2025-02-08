# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  currency   :string(3)        not null
#  price      :decimal(21, 3)   not null
#  state      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  brand_id   :uuid
#  user_id    :uuid
#
# Indexes
#
#  index_products_on_brand_id  (brand_id)
#  index_products_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#  fk_rails_...  (user_id => users.id)
#
class Product < ApplicationRecord
  # concerns
  include HasFieldLimit

  # attributes
  money_column :price, currency_column: :currency
  enum :state, { active: 0, archived: 1 }

  # validations
  validates :currency, presence: true
  validate :currency_must_exist
  validates :price, presence: true

  # associations
  belongs_to :brand
  belongs_to :user

  private

  def currency_must_exist
    return if Money::Currency.find(currency)

    errors.add(:currency, 'is not exist')
  end
end
