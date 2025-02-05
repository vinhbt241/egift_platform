# frozen_string_literal: true

module ExceptionFilter
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid,
                ActiveRecord::RecordNotDestroyed,
                with: ->(e) { log_error(e) && render_api_error(APIError::RecordInvalidError.new(e.record.errors)) }

    rescue_from ActiveRecord::RecordNotFound,
                with: ->(e) { log_error(e) && render_api_error(APIError::NotFoundError.new) }

    rescue_from APIError::StandardError,
                with: ->(e) { log_error(e) && render_api_error(e) }
  end

  private

  def log_error(error)
    Rails.logger.error(error)
  end

  def render_api_error(error)
    render json: error, status: error.status
  end
end
