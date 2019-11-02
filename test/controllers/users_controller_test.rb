require "test_helper"

describe UsersController do
  
  describe "auth_callback (#create)" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      
      perform_login
      
      must_redirect_to root_path
      
      expect(User.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      new_user = User.new(name:"Hallie", email: "hfake@fake.com", uid: 473837 )
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      expect{ get auth_callback_path(:github) }.must_change "User.count", 1
      
      must_redirect_to root_path
      
    end
    
    it "redirects to the login route if given invalid user data" do
      new_user = User.new(name:"Hallie", email: "hfake@fake.com", uid: nil )
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      expect{ get auth_callback_path(:github) }.wont_change "User.count"
      
      must_redirect_to root_path
    end
  end
  
  describe "logout (#destroy)" do
    before do
      perform_login(users(:dan))
    end
    
    it "logs out an already logged-in user" do
      expect{ delete logout_path }.wont_change "User.count"
      expect(session[:user_id]).must_equal nil
      expect(flash[:success]).must_equal "Successfully logged out!"
      must_redirect_to root_path
    end 
  end
end
