# frozen_string_literal: true

require 'jwt_token'

module API
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_request!
    end
  end
end
