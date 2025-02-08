# frozen_string_literal: true

# == Schema Information
#
# Table name: brands
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  state      :integer          default("active")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_brands_on_name_and_user_id  (name,user_id) UNIQUE
#  index_brands_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Brand < ApplicationRecord
  # concerns
  include HasFieldLimit

  # attributes
  enum :state, { active: 0, archived: 1 }

  # validations
  validates :name, presence: true, uniqueness: { scope: :user_id }

  # assocations
  belongs_to :user
  has_many :products, dependent: :destroy
end
