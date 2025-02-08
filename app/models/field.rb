# frozen_string_literal: true

# == Schema Information
#
# Table name: fields
#
#  id                      :uuid             not null, primary key
#  data                    :text
#  field_customizable_type :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  field_customizable_id   :uuid
#  field_type_id           :uuid
#
# Indexes
#
#  index_fields_on_field_customizable  (field_customizable_type,field_customizable_id)
#  index_fields_on_field_type_id       (field_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (field_type_id => field_types.id)
#
class Field < ApplicationRecord
  # associations
  belongs_to :field_type
  belongs_to :field_customizable, polymorphic: true

  # validations
  validate :must_be_within_field_customizable_limit

  private

  def must_be_within_field_customizable_limit
    return unless field_customizable.try(:field_limit_concern_included?)
    return unless field_customizable.fields.count > field_customizable.field_limit

    errors.add(
      :field_customizable,
      "must be less than #{field_customizable.field_limit}"
    )
  end
end
