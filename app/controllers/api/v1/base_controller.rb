module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :require_login, raise: false

      before_action :authenticate_api_user!

      private 

      def authenticate_api_user!
        token = request.headers['Authorization']&.split(' ')&.last

        @current_api_user = User.find_by(auth_token: token)

        render json: { error: "Unauthorized", message: 'Please provide a valid token'}, status: :unauthorized unless @current_api_user
      end

      def current_api_user
        @current_api_user
      end
    end
  end
end