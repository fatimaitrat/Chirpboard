class PostsController < ApplicationController
  before_action :require_login
  def new 
    @post = Post.new
  end
  def create 
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Posted!"
    else
      render :new, status: :unprocessable_entity
      
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to root_path, notice: "Post deleted"
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
