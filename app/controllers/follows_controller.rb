class FollowsController < ApplicationController
  before_action :require_login

  def create
    user = User.find(params[:followed_id])

    current_user.follow(user)

    redirect_to user_profile_path(user.username)
  end

  def destroy
    follow = Follow.find_by!(id: params[:id], follower: current_user)
    user = follow.followed

    follow.destroy

    redirect_to user_profile_path(user.username)
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "You must be logged in to follow users."
    end
  end
end
