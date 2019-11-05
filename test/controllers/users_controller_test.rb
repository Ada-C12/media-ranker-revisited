require "test_helper"

describe UsersController do

 describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
        start_count = User.count
        user = users(:kari)

        perform_login(user)
        must_redirect_to root_path
        expect(session[:user_id]).must_equal  user.id

        # Should *not* have created a new user
        User.count.must_equal start_count
    end

    it "creates an account for a new user and redirects to the root route" do

      new_user = User.new(provider: "github", uid: 99999, username: "test_user")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      get auth_callback_path(:github)

     expect { get auth_callback_path(:github) }.must_change "User.count", 1

     must_redirect_to root_path  

      # The new user's ID should be set in the session
      expect(session[:user_id]).must_equal User.last.id

    end

    it "redirects to the login route if given invalid user data" do

      user = User.new(username:"Kathy", email:"whatev@git.com", uid: nil)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      expect{ get auth_callback_path(:github) }.wont_change "User.count"

      must_redirect_to root_path
    end
  end

  describe 'index' do
    it 'succeeds when there are users' do 
      User.count.must_be :>,0
      get users_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "succeeds for an extant user ID" do
      perform_login = users(:kari)
      get user_path(perform_login.id)
      must_respond_with :success
    end


    it "renders 404 not_found for a bogus user ID" do

      get user_path(-1)
      must_respond_with :not_found
    end
  end
end
  
