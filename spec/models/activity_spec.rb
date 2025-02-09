# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id             :uuid             not null, primary key
#  name           :string           not null
#  notes          :jsonb
#  trackable_type :string
#  type           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  trackable_id   :uuid
#
# Indexes
#
#  index_activities_on_trackable  (trackable_type,trackable_id)
#
require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:trackable) }
  end
end
