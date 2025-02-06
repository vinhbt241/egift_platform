# frozen_string_literal: true

class JwtToken
  class << self
    def encode(payload)
      JWT.encode(payload, ENV['JWT_SECRET'])
    end

    def decode(token)
      JWT.decode(token, ENV['JWT_SECRET'])[0]
    rescue StandardError
      nil
    end
  end
end
