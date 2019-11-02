class UsersController < ApplicationController
  
  def create    
    if session[:user_id]
      flash[:warning] = "A user is already logged in."
      redirect_back(fallback_location: root_path)
    else
      auth_hash = request.env["omniauth.auth"]
      
      user = User.find_by(uid: auth_hash[:uid], provider: "github")
      
      if user
        # User was found in the database
        flash[:success] = "Logged in as returning user #{user.username}"
      else
        # User doesn't match anything in the DB
        # Attempt to create a new user
        user = User.build_from_github(auth_hash)
        
        if user.save
          flash[:success] = "Logged in as new user #{user.username}"
        else
          # Couldn't save the user for some reason. If we
          # hit this it probably means there's a bug with the
          # way we've configured GitHub. Our strategy will
          # be to display error messages to make future
          # debugging easier.
          flash[:warning] = "Could not create new user account: #{user.errors.messages}"
          return redirect_to root_path
        end
      end
      
      # If we get here, we have a valid user instance
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
      
      redirect_back(fallback_location: root_path)
    end
  end
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end
  
end

private

def user_params
  return params.require(:user).permit(:username, :email, :provider, :uid)
end
