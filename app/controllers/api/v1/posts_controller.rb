module Api
  module V1
    class PostsController < ApplicationController
      skip_before_action :require_login, raise: false

      include Pagy::Backend


      def index

        @pagy, @posts = pagy(Post.order(created_at: :desc), item: 10)
        posts = Post.order(created_at: :desc).limit(10)

        

        render json: {
          data: @posts.as_json(
            only: [:id, :body, :created_at],
            include: { user: { only: [:username, :name] } }

          ),
          meta: {
            current_page: @pagy.page,
            next_page: @pagy.next,
            total_pages: @pagy.pages,
            total_count: @pagy.count
          }
        }
      end
    end
  end
end