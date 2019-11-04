require "test_helper"

describe UsersController do
  describe "guest user" do
    describe "index" do
      it "redirects when no user is logged in" do
        get users_path

        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "show" do
      it "redirects if there is no logged in user" do
        user_id = users(:kari).id

        get user_path(user_id)

        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
  end
  describe "auth_callback" do
    describe "logged in users" do
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
        start_count = User.count
        invalid_user = User.new(provider: "github", username: "", email: "invaliduser@none.org")

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(invalid_user))
        get auth_callback_path(:github)

        must_redirect_to root_path

        User.count.must_equal start_count

        session[:user_id].must_be_nil
      end
    end
    describe "logout" do
      it "will log out an existing user" do
        perform_login

        expect {
          delete logout_path
        }.wont_change "User.count"

        expect(session[:user_id]).must_be_nil
      end
    end
  end
end
