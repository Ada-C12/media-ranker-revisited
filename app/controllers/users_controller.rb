class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    if user 
      flash[:status] = :success
      flash[:messages] = { message: ["Logged in as returning user #{user.username}"] }
      session[:user_id] = user.id
    else
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:status] = :success 
        flash[:messages] = { message: ["Logged in as new user #{user.username}"] }
        session[:user_id] = user.id
      else
        flash[:status] = :failure
        flash[:messages] = user.errors.messages
      end 
    end 
    redirect_to root_path
  end 
  
  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"
    redirect_to root_path
  end
end
