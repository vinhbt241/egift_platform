# frozen_string_literal: true

module API
  module V1
    class UsersController < BaseController
      before_action :authenticate_request!, only: [:me]

      def create
        user = User.create!(user_params)

        render_resource(user, view: :with_token, status: :created)
      end

      def me
        render_resource(current_user)
      end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
