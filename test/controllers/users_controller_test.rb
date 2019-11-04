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
      
      user = User.new(nickname: "test user", name: "test", uid: 1321421421, email: "test", provider: "github")
      
      perform_login(user)
      
      must_redirect_to root_path
      session[:user_id].must_equal User.last.id
      User.count.must_equal start_count+1
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count
      
      user = User.new()
      
      perform_login(user)
      
      must_redirect_to root_path
      session[:user_id].must_be_nil
      User.count.must_equal start_count
    end
  end
  
  describe "logout" do
    it "logs out a user that is logged in" do
      start_count = User.count
      
      user = users(:grace)
      perform_login(user)
      
      session[:user_id].must_equal user.id
      
      delete logout_path
      
      must_redirect_to root_path
      session[:user_id].must_be_nil
      User.count.must_equal start_count
    end
    
    it "doesn't do anything if no users are logged in" do
      start_count = User.count
      
      delete logout_path
      
      must_redirect_to root_path
      session[:user_id].must_be_nil
      User.count.must_equal start_count
    end
  end
end
