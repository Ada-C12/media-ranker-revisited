class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end
  
  def create
    if session[:user_id]
      flash[:warning] = "A user is already logged in."
      redirect_back(fallback_location: root_path)
    else
      auth_hash = request.env["omniauth.auth"]
      
      user = User.find_by(uid: auth_hash[:uid], provider: "github")
      if user
        flash[:success] = "Logged in as returning user #{user.username}"
      else
        user = User.build_from_github(auth_hash)
        if user.save
          flash[:success] = "Logged in as new user #{user.username}"
        else
          flash[:warning] = "Could not create new user account: #{user.errors.messages}"
          return redirect_to root_path
        end
      end
      
      session[:user_id] = user.id
      return redirect_to root_path
    end
  end
  
  def destroy
    if session[:user_id] == nil
      flash[:warning] = "You cannot log out because you are not logged in."
    else
      session[:user_id] = nil
      flash[:success] = "Successfully logged out!"
    end
    
    redirect_to root_path
  end
end
