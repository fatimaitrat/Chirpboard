module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_api_user!, only: [:create]

      def create
        user = User.find_by(username: params[:username])

        if user&.authenticate(params[:password])
          render json: {
            message: "Login successful",
            token: user.auth_token,
            user: {id: user.id, username: user.username, name: user.name}
          }, status: :ok
        else
          render json: { error: "Invalid credential" }, status: :unauthorized
        end
      end
    end
  end
end