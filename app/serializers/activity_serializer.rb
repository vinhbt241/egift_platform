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
class ActivitySerializer < ApplicationSerializer
  identifier :id

  fields :type, :name, :notes, :created_at, :trackable_type

  association :trackable, blueprint: ->(trackable) { trackable.serializer }, default: {}
end
