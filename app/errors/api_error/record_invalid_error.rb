# frozen_string_literal: true

module APIError
  class RecordInvalidError < StandardError
    def initialize(errors = [])
      super(
        message: 'Unprocess entity',
        errors:,
        status: 422
      )
    end
  end
end
