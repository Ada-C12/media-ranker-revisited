require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count  
      user = users(:grace)
      
      perform_login(user)
      
      session[:user_id].must_equal user.id
      must_redirect_to root_path
      User.count.must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      user = User.create(provider: "github", uid: 99999, username: "test_user", email: "test@user.com", name: "Tester")
      
      perform_login(user)
      
      session[:user_id].must_equal User.last.id
      must_redirect_to root_path
      User.count.must_equal start_count + 1
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count  
      bad_user = User.create(provider: "github", uid: 99999)
      
      perform_login(bad_user)
      
      assert_nil(session[:user_id])
      must_redirect_to root_path
      User.count.must_equal start_count
    end
  end
end
