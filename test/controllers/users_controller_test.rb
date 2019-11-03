require "test_helper"

describe UsersController do
  let (:dan) { users(:dan) }
  let (:kari) { users(:kari) }
  
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      
      # OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(dan))
      # get auth_callback_path(:github)
      # above 2 lines refactored into line below, from test_helpers.rb
      perform_login(dan)
      
      must_redirect_to root_path
      session[:user_id].must_equal dan.id
      expect(flash[:success]).must_equal "Logged in as returning user #{dan.name}"
      User.count.must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
    end
    
    it "redirects to the login route if given invalid user data" do
    end
  end
end
