class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_current_user

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new("Not Found")
  end

  def find_current_user
    if session[:user_id]
      @login_user ||= User.find_by(id: session[:user_id])
    end
  end

  def require_login
    if current_user.nil?
      flash[:error] = "You must be logged in as an authorized user to access this page."
      return redirect_to root_path
    end
  end


end
