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
require 'rails_helper'

RSpec.describe Brand, type: :model do
  subject { create(:brand) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
  end

  describe 'attributes' do
    it { is_expected.to define_enum_for(:state) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:fields) }
    it { is_expected.to belong_to(:user) }
  end
end
