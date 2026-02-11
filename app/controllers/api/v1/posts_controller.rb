module Api
  module V1
    class PostsController < BaseController
      #skip_before_action :require_login, raise: false

      include Pagy::Backend


      def index
        @pagy, @posts = pagy(Post.includes(:user).order(created_at: :desc),limit: 20)
        
        #posts = Post.order(created_at: :desc).limit(10)
      end

      def create 
        @post = current_api_user.posts.build(post_params)

        if @post.save 
          render :show, status: :created
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @post = current_api_user.posts.find_by(id: params[:id])
        if @post
          @post.destroy
          render json: {message: "Post deleted successfully" }, status: :ok

        else 
          render json: { error: "Posts not found or permission denied" }, status: :not_found
        end
      
      end

      private 
      def post_params
        params.require(:post).permit(:body)
      end
    end
  end
end