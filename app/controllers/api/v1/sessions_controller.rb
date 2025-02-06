# frozen_string_literal: true

module API
  module V1
    class SessionsController < BaseController
      def create
        user = User.find_by!(email: session_params[:email])

        if user.authenticate(session_params[:password])
          render_resource(user, view: :with_token, status: :created)
        else
          render_api_error(APIError::NotFoundError.new)
        end
      end

      private

      def session_params
        params.require(:session).permit(:email, :password)
      end
    end
  end
end
