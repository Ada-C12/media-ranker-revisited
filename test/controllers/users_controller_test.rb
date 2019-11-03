require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      
      user = users(:grace)
      perform_login(user)
      
      must_redirect_to root_path
      session[:user_id].must_equal user.id
      User.count.must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      
      user = User.new(provider: "github", uid: 99999, username: "test_user", email: "test@user.com")
      perform_login(user)
      
      must_redirect_to root_path
      User.count.must_equal start_count + 1
      session[:user_id].must_equal User.last.id
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count
      
      user = User.new()
      perform_login(user)
      
      must_redirect_to root_path
      User.count.must_equal start_count
      session[:user_id].must_be_nil
      
      expect(user.valid?).must_equal false
      expect(user.errors.messages).must_include :username
      expect(user.errors.messages[:username]).must_equal ["can't be blank"]
    end
  end
  
  describe "logout" do
    it "can log out, set session_id to nil, redirect to root path" do
      start_count = User.count
      
      user = users(:grace)
      perform_login(user)
      
      session[:user_id].must_equal user.id
      
      delete logout_path
      
      expect(session[:user_id]).must_be_nil
      must_redirect_to root_path
    end
    
    it "can log out when no user is logged in" do   
      delete logout_path
      
      expect(session[:user_id]).must_be_nil
      must_redirect_to root_path
    end
  end
end
