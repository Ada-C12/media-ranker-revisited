class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new("Not Found")
  end

  private

  def find_user
    @login_user = nil

    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
    return @login_user
  end

  def require_login
    find_user
    
    if @login_user.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to root_path
    end 
  end
end
