class ApplicationController < ActionController::Base
  
  private
  def current_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
    
    if @current_user.nil?
      session[:user_id] = nil
    end
  end  
end
