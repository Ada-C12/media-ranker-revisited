require "test_helper"
require "pry"
describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      user = users(:dan)
      perform_login(user)
      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id

      expect(User.count).must_equal start_count
    end

    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      user = User.new(provider: "github", uid: 99999, username: "test_user", email: "test@user.com")

      perform_login(user)

      must_redirect_to root_path

      expect _(User.count).must_equal start_count + 1

      expect _(session[:user_id]).must_equal User.last.id
    end

    it "redirects to the login route if given invalid user data" do
      OmniAuth.config.test_mode = true

      OmniAuth.config.mock_auth[:github] =
        OmniAuth::AuthHash.new(mock_auth_hash(User.new))

      expect { get auth_callback_path(:github) }.wont_change "User.count"

      must_redirect_to root_path
      assert_nil (session[:user_id])
    end
  end

  describe "destroy" do
    it "logs out a logged in user" do
      start_count = User.count
      user = users(:kari)

      perform_login(user)
      must_redirect_to root_path
      expect _(session[:user_id]).must_equal user.id

      delete logout_path

      must_redirect_to root_path
      assert_nil (session[:user_id])
    end
  end
end
