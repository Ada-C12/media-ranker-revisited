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
      flash[:result_text] = "Logged in as returning user #{user.username}"
    else
      user = User.build_from_github(auth_hash)

      if user.save
        flash[:status] = :success
        flash[:result_text] = "Logged in as new user #{user.username}"
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = user.id
    return redirect_to root_path
  end

  def destroy
    if session[:user_id]
      session[:user_id] = nil
      flash[:status] = :success
      flash[:result_text] = "Successfully logged out!"
      redirect_to root_path
      return
    else
      flash[:status] = :failure
      flash[:result_text] = "You are not logged in"
      redirect_to root_path
      return
    end
  end
end
