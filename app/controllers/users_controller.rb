class UsersController < ApplicationController
  def index
    if @login_user 
      @users = User.all
    else
      flash[:status] = :failure
      flash[:result_text] = "You must log in to do that"
      redirect_to root_path
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    if user
      # User was found in the database
      flash[:status] = :success
      flash[:result_text] = "Logged in as returning user #{user.username}"
    else
      # User doesn't match anything in the DB
      user = User.build_from_github(auth_hash)

      if user.save
        flash[:status] = :success
        flash[:result_text] = "Logged in as new user #{user.username}"
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not create new user account:"
        flash[:messages] = user.errors.messages
        return redirect_to root_path
      end
    end

    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out!"

    redirect_to root_path
  end
  
end
