class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def create
    auth_hash = request.env['omniauth.auth']

    user = User.find_by(uid: auth_hash[:uid], provider: 'github')
    if user
      flash[:status] = :success
      flash[:result_text] = "Successfully logged in as existing user #{user.username}"
    else
      return redirect_to root_path unless auth_hash[:uid]
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:status] = :success
        flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
      else          i
        flash[:status] = :failure
        flash[:result_text] = "Could not log in"
        flash[:messages] = user.errors.messages
        # render "login_form", status: :bad_request
      end
    end
    session[:user_id] = user&.id
    return redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end
