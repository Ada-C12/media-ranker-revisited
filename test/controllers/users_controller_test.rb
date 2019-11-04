require "test_helper"
require "pry"

describe UsersController do

  # Tell OmniAuth to use mock data instead of connecting to Github
  # Define a perform_login function for our tests that sends the login request using fixture data.
  describe "auth_callback" do
    # testing that this route is doing what it is suppose to do
    it "logs in an existing user and redirects to the root route" do
      # Count the users, to make sure we're not (for example) creating
      # a new user every time we get a login request
      start_count = User.count

      # Get a user from the fixtures
      user = users(:khabib)

      # Tell OmniAuth to use this user's info when it sees
      # an auth callback from github
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      # Send a login request for that user
      # Note that we're using the named path for the callback, as defined
      # in the `as:` clause in `config/routes.rb`
      get auth_callback_path(:github)

      must_redirect_to root_path

      # Since we can read the session, check that the user ID was set as expected
      session[:user_id].must_equal user.id
      

      # Should *not* have created a new user
      User.count.must_equal start_count
    end

    it "creates a new user and redirects" do
      start_count = User.count
      user = User.new(username: "taylor32", uid: 999, provider: "github", name: "Blaire", email: "taylor@gmail.com")

      perform_login(user)
      must_redirect_to root_path

      # Should have created a new user
      User.count.must_equal start_count + 1

      # The new user's ID should be set in the session
      session[:user_id].must_equal User.last.id
    end 

    it "redirects to the login route if given invalid user data" do
      new_user = User.new(username: "taylor32", uid: nil, provider: "github", name: "Blaire", email: "taylor@gmail.com")
      
      perform_login(new_user)

      expect{ get auth_callback_path(:github) }.wont_change "User.count"

      must_redirect_to root_path
    end 
  end 

  describe "logout" do
    it "logs out a user and redirects" do
      user = users(:khabib)
  

      perform_login(user)

      delete logout_path

      session[:user_id].must_equal nil

      must_redirect_to root_path
    end 

    
  end 
end
