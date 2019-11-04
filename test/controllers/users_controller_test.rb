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
      new_user = User.new(provider: "github", uid: 99999, name: "test_user", email: "test@user.com")
      perform_login(new_user)
      
      must_redirect_to root_path
      User.count.must_equal start_count + 1
      session[:user_id].must_equal User.last.id
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count
      invalid_user = User.new(provider: nil, uid: nil, name: nil, email: nil)
      perform_login(invalid_user)
      
      must_redirect_to root_path
      User.count.must_equal start_count 
      assert_nil(session[:user_id])
    end
    
    it "logs out a logged-in user" do
      perform_login(users(:grace))
      delete logout_path 
      assert_nil(session[:user_id])
    end 
  end
end

