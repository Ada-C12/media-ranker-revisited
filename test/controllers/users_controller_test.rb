require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      user = User.find_by(username: "dan")
      start_count = User.count
      OmniAuth.config.mock_auth[:github] =
      OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path(:github)
      
      must_redirect_to root_path
      
      expect(session[:user_id]).must_equal user.id
      
      User.count.must_equal start_count
    end
    
    it "creates a new user" do
      user = User.new(provider: "github", uid: 66447, username: "test_user", email: "test@user.com")
      OmniAuth.config.mock_auth[:github] =
      OmniAuth::AuthHash.new(mock_auth_hash(user))
      
      expect{
        get auth_callback_path(:github)
      }.must_change "User.count", 1
      
      must_redirect_to root_path
      
      expect(session[:user_id]).must_equal User.last.id
      
      
    end
    
    it "logs in an existing user" do
      start_count = User.count
      user = users(:kari)
      perform_login(user)
      
      must_redirect_to root_path
      session[:user_id].must_equal user.id
      
      User.count.must_equal start_count
      
    end
    
    it "logs out a currently logged in user" do
      user = users(:kari)
      perform_login(user)
      session[:user_id].must_equal user.id
      
      delete logout_path
      
      assert_nil(session[:user_id])
      
      
    end
    
    
    
  end
  
end