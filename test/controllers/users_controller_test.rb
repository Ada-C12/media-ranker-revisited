require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      user = users(:jan)
      perform_login(user)

      must_redirect_to root_path
      session[:user_id].must_equal user.id
      User.count.must_equal start_count
    end
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      user = User.new(provider: "github", uid: 12345, name: "test_user", email: "test@user.com")
      perform_login(user)

      must_redirect_to root_path
      User.count.must_equal start_count + 1
      session[:user_id].must_equal User.last.id
    end
    it "redirects to the login route if given invalid user data" do
      user = User.new(provider: "github", uid: nil, name: nil, email: nil)
      perform_login(user)

      must_redirect_to root_path
    end
  end
  describe "logout functionality" do
    it "can log out user" do
      user = users(:dan)
      perform_login(user)
      start_count = User.count
      delete logout_path
      _(User.count).must_equal start_count
      _(session[:user_id]).must_equal nil
      _(flash[:success]).wont_be_nil
    end
  end
end
