class HomeController < ApplicationController
  def index
    
    if logged_in?
      
      @post = Post.new
      # @posts = Post.all.order(created_at: :desc)

      feed_ids = current_user.following.ids << current_user.id
      #@pagy, @posts = pagy(Post.where(user_id: feed_ids).order(created_at: :desc), item: 10)
      @pagy, @posts = pagy(Post.all.order(created_at: :desc), limit: 10)
    else
      @posts =[]
    end
  end
end
