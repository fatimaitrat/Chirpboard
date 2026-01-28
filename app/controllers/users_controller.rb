class UsersController < ApplicationController
  allow_browser versions: :modern

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by!(username: params[:username])
  end

  def edit 
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_profile_path(@user.username),notice: "Profile Updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy_avatar
    current_user.avatar.purge
    redirect_to edit_user_path(current_user), notice: "Profile picture Removed"
  end
  private
  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :bio, :avatar)
  end
end
