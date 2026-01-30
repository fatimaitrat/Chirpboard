class PostsApiController < ApplicationController
  skip_before_action :require_login, raise: false

  def index
    posts = Post.order(created_at: :desc).limit(20)
    render json: posts.as_json(
      only: [ :id, :body, :created_at ],
      include: { user: { only: [ :username, :name ] } }
    )
  end
end
