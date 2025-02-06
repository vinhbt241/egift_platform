# frozen_string_literal: true

module HasFieldLimit
  extend ActiveSupport::Concern

  DEFAULT_FIELD_LIMIT = 5

  included do
    # associations
    has_many :fields, as: :field_customizable, dependent: :destroy

    def field_limit
      DEFAULT_FIELD_LIMIT
    end

    def field_limit_concern_included?
      true
    end
  end
end
