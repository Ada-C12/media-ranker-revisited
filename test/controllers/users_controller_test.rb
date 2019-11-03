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
      expect(session[:user_id]).must_equal dan.id
      expect(flash[:success]).must_equal "Logged in as returning user #{dan.name}"
      expect(User.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      new_user = User.new( name: "lisa", provider: "github", uid: 333, email: "lisa@simpsons.com" )
      
      perform_login(new_user)
      expect(session[:user_id]).must_equal User.last.id
      expect(flash[:success]).must_equal "Logged in as new user #{new_user.name}"
      expect(User.count).must_equal (start_count+1)
    end
    
    it "redirects to the login route if given invalid user data" do
    end
  end
end
