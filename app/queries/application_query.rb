# frozen_string_literal: true

class ApplicationQuery
  attr_reader :scope

  class << self
    def call(scope:, filters:)
      new(scope).call(filters:)
    end
  end

  def initialize(scope)
    @scope = scope
  end

  def call
    raise NotImplementedError, "You must define 'call' as instance method in #{self.class.name} class."
  end
end
