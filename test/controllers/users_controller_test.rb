require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count  
      user = users(:grace)
      
      # Tell OmniAuth to use this user's info when it sees an auth callback from github
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      
      # Send a login request for that user
      get auth_callback_path(:github)
      
      must_redirect_to root_path
      session[:user_id].must_equal user.id
      User.count.must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      
      user = User.create(provider: "github", uid: 99999, username: "test_user", email: "test@user.com", name: "Tester")
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path(:github)
      
      must_redirect_to root_path
      
      User.count.must_equal start_count + 1
      
      session[:user_id].must_equal User.last.id
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count  
      bad_user = User.create(provider: "github", uid: 99999)
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(bad_user))
      
      get auth_callback_path(:github)
      
      must_redirect_to root_path
      assert_nil(session[:user_id])
      User.count.must_equal start_count
    end
  end
end
