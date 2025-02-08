# frozen_string_literal: true

module APIError
  class UnknownCurrencyError < StandardError
    def initialize
      super(
        message: 'Invalid iso4217 currency',
        status: 422
      )
    end
  end
end
