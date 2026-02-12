module Api
  module V1 
    class UsersController < BaseController
      #We don't need to be logged in to Sign up!
      skip_before_action :authenticate_api_user!, only: [:create]
      before_action :set_user, only: [:follow, :unfollow]
      def create
        user = User.new(user_params)

        if user.save

          #API response send json and token
          render json: {
            message: "User createed suceessfully",
            token: user.auth_token,
            user: {id: user.id, username: user.username, email: user.email }

          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def follow
        if current_api_user == @user
          render json: { error: "You can not follow yourself" }, status: :unprocessable_entity
          return
        end
        
        if current_api_user.following?(@user)
          render json: { error: "You are already following #{@user.username}" }, status: :unprocessable_entity
          return
        end

        current_api_user.follow(@user)
        render json: { message: "You are now following #{@user.username}" },status: :ok
      end

      def unfollow

        unless current_api_user.following?(@user)
          render json: { error: "You are not following #{@user.username}" }, status: :unprocessable_entity
          return
        end

        current_api_user.unfollow(@user)
        render json: { message: "You have unfollowed #{@user.username}" }, status: :ok
      end

      private
      def user_params
        params.require(:user).permit(:username, :email, :password, :name, :bio)
      end

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :not_found
      end
    end
  end
end