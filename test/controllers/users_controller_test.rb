require "test_helper"

describe UsersController do
  describe "login" do
    it "can successfully login a user" do
      user = User.first
      
      user_info = {
        user:
        {
          username: user.username
        }
      }
      post login_path, params: user_info
      
      expect(session[:user_id]).must_equal user.id
      
      get current_user_path
      
      must_respond_with :success
    end
    
    it "creates an account when logging in a new user" do
      user = User.new
      
      expect{ post login_path, params: user_info }.must_differ "User.count", 1
      
      expect(session[:user_id]).must_equal user.id
      
      must_respond_with :success
    end
    
    it "does not create a new account when logging in an existing user" do
      user = User.first
      
      expect{post login_path, params: user_info }.must_differ "User.count", 0
      
      must_respond_with :success
    end
    
    it "will not login a user without the proper credentials" do
      user = nil
      
      expect{ post login_path, params: user_info}.must_differ "User.count", 0
      
      expect(session[:user_id]).must_equal nil
    end
  end
  
  describe "logout" do
    it "can successfully logout a user" do
      post logout_path
      
      expect(session[:user_id]).must_equal nil
      
      must_respond_with :success
    end    
  end
end
