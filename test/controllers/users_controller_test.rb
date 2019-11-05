require "test_helper"
describe UsersController do
  
  describe "auth_callback" do
    it "logs-in an existing user and redirects" do
      start_count = User.count 
      user = users(:dan)

      perform_login(user)
      # OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

      # get auth_callback_path(:github)

      must_redirect_to root_path
      _(session[:user_id]).must_equal user.id 
      _(User.count).must_equal start_count
    end

    it "creates an account for a new user and redirects" do
      start_count = User.count
      user = User.new(provider: "github", uid: 1111, name: "valid_user", email: "valid@user.com")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path(:github)

      must_redirect_to root_path
      
      (User.count).must_equal start_count + 1
      (session[:user_id]).must_equal User.last.id
    end

    it "redirects to the login page if given invalid user data" do
      user = users(:dan)
      user.name = nil

      perform_login(user)

      assert(flash[:error] = "Could not create new user account: #{user.errors.messages}")
      must_redirect_to root_path
    end
  end

  describe "logged-in user" do
    it "can logout on #destroy action" do
      user = users(:dan)
      perform_login(user)

      delete logout_path

      assert(flash[:success] = "Successfully logged out!")
      must_redirect_to root_path
    end
  end
end
