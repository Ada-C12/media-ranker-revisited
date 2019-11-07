class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]
  before_action :user_not_found, only: [:show, :edit]#, :destroy]
  before_action :find_user_session, only: [:show, :index]
  def index
    @users = User.all
  end
  
  def show; end
  
  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    
    if user
      flash[:success] = "Logged in as returning user #{user.name}"
      session[:user_id] = user.id
      return redirect_to user_path(user.id)
    else
      user = User.build_from_github(auth_hash)
      
      if user.save
        flash[:success] = "Logged in as new user #{user.name}"
      else
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
      end
    end
    
    session[:user_id] = user.id
    return redirect_to root_path
  end
  
  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"
    
    redirect_to root_path
  end
  
  private
  
  def user_params
    return params.require(:user).permit(:id, :name, :join_date, :uid, :provider, :email)
  end
  
  def find_user
    @user = User.find_by(id: params[:id])
  end
  
  def user_not_found
    if @user.nil?
      flash[:redirect] = "User with ID: #{params[:id]} was not found."
      redirect_to root_path
      return
    end
  end
  
  def find_user_session
    if session[:user_id] == nil
      flash[:error] = "You must be logged in to see this page."
      redirect_to root_path
    end
  end
end
