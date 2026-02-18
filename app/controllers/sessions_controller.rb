class SessionsController < ApplicationController
  allow_browser versions: :modern

  def new
  end

  def create
    puts "--- DEBUGGING LOGIN ---"
    puts "Email Params: #{params[:email]}"
    
    user = User.find_by(email: params[:email])
    puts "User Found: #{user.inspect}"
    
    if user
      puts "Password match?: #{user.authenticate(params[:password])}"
    end
    puts "-----------------------"
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully!", status: :see_other
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity

    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!", status: :see_other
  end
end
