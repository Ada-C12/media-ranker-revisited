require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count

      user = users(:dan)
      perform_login(user)

      must_redirect_to root_path

      session[:user_id].must_equal user.id

      User.count.must_equal start_count
    end

    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      user = User.new(provider: "github", username: "test_user", email: "test@user.com")

      perform_login(user)

      must_redirect_to root_path

      User.count.must_equal start_count + 1

      session[:user_id].must_equal User.last.id
    end

    it "redirects to the login route if given invalid user data" do
      # start_count = User.count
      # invalid_user = User.new(provider: "github", username: "", email: "invaliduser@none.org")

      # OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(invalid_user))
      # get auth_callback_path(:github)

      # must_respond_with :error

      # User.count.must_equal start_count

      # session[:user_id].must_be_nil
      new_user = User.new(name: "Kathy", email: "whatev@git.com", uid: nil)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      expect { get auth_callback_path(:github) }.wont_change "User.count"

      must_redirect_to root_path
    end
  end
end
