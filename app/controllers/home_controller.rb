class HomeController < ApplicationController
  def index
    if logged_in?
      @post = Post.new
      @posts = Post.all.order(created_at: :desc)
    end
  end
end
