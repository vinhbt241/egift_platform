# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # remove csrf protect when in development
  protect_from_forgery with: :null_session, if: -> { Rails.env.development? }

  include JSONAPIRender
  include ExceptionFilter
end
