require "test_helper"

describe UsersController do
  
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      
      perform_login
      
      must_redirect_to root_path
      
      expect(User.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      # new_user = users(:grace)
      # new_user.uid = 420
      new_user = User.new(name:"Kathy", email: "whatev@git.com", uid: 473837 )
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      expect{ get auth_callback_path(:github) }.must_change "User.count", 1
      
      must_redirect_to root_path
      
    end
    
    it "redirects to the login route if given invalid user data" do
      new_user = User.new(name:"Kathy", email: "whatev@git.com", uid: nil )
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      expect{ get auth_callback_path(:github) }.wont_change "User.count"
      
      must_redirect_to root_path
    end
  end
end
