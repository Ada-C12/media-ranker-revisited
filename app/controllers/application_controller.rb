class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :find_user
  
  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError.new("Not Found")
  end
  
  private
  
  def find_user
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
  end
  
  def determine_login
    if session[:user_id].nil?
      flash[:status] = :failure
      flash[:result_text] = "You cannot complete action unless you are logged in"
      return redirect_to root_path
    end
  end
end
