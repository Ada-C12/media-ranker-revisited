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
      user = User.new(provider: "github", uid: 99999, username: "test", name: "test_user", email: "test@user.com")
    
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path(:github)
    
      must_redirect_to root_path
    
      User.count.must_equal start_count + 1
    
      session[:user_id].must_equal User.last.id
    end

    it "does not log in a user if given invalid user data and responds with bad_request" do
      start_count = User.count
      user = User.new(provider: "github", uid: 99999, name: "test_user", email: "test@user.com")
    
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      
      expect{ get auth_callback_path(:github) }.wont_change "User.count"
    
      must_respond_with :bad_request
    
      assert_nil (session[:user_id])
    end
  end

  describe "destroy" do
    it "logs out a logged in user" do
      start_count = User.count
      user = users(:ada)
      
      perform_login(user)
      must_redirect_to root_path
      expect (session[:user_id]).must_equal user.id
      
      delete logout_path
      
      must_redirect_to root_path
      assert_nil (session[:merchant_id])
    end
  end
end
