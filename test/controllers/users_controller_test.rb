require "test_helper"

describe UsersController do
  describe "login" do
    it "can successfully login a user" do
      user = User.first
      
      perform_login(user)
      
      expect(session[:user_id]).must_equal user.id
    end
    
    it "creates an account when logging in a new user" do
      user_count = User.all.length
      user = User.create(provider: "github", uid: "123", email: "email", name: "name", username: "username")
      
      perform_login(user)
      
      expect(session[:user_id]).must_equal user.id      
      User.count.must_equal user_count + 1
    end
    
    it "does not create a new account when logging in an existing user" do
      user = User.first
      user_count = User.all.length
      
      perform_login(user)
      
      User.count.must_equal user_count      
    end
    
    it "will not login a user without the proper credentials" do
      user = User.create(provider: "facebook", uid: "0", email: "email", name: "name", username: "username")
      
      perform_login(user)
      
      expect(session[:user_id]).must_equal nil
    end
  end
  
  describe "logout" do
    it "can successfully logout a user" do
      post logout_path
      
      expect(session[:user_id]).must_equal nil
      
      must_respond_with :redirect
    end    
  end
end
