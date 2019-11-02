require "test_helper"

describe UsersController do
  describe "create/login" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      user = users(:dan)
      
      perform_login(user)
      
      must_redirect_to root_path
      session[:user_id].must_equal user.id
      expect(User.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      user = User.new(provider: "github", uid: 99999, username: "test_user", email: "test@user.com")
      
      perform_login(user)
      
      must_redirect_to root_path
      session[:user_id].must_equal User.last.id
      expect(User.count).must_equal start_count + 1
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count
      new_user = User.new(provider: "github", uid: 19999, email: "test@user.com")
      
      perform_login(new_user)
      
      must_redirect_to root_path
      expect(User.count).must_equal start_count
    end
  end
  
  describe "destroy/logout" do
    it "logs out a logged-in user" do
      start_count = User.count
      user = users(:dan)
      
      perform_login(user)
      session[:user_id].must_equal user.id
      
      delete logout_path
      
      session[:user_id].must_be_nil
      must_redirect_to root_path
      expect(User.count).must_equal start_count
    end
    
    it "does nothing if no one is logged in" do
      delete logout_path
      
      session[:user_id].must_be_nil
      must_redirect_to root_path
    end
  end
  
end
