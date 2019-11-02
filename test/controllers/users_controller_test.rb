require "test_helper"

describe UsersController do
  describe "login" do
    it "logs in an exisiting user and redirects to the root route" do
      start_count = User.count
      existing_user = users(:dan)
      perform_login(existing_user)
      
      expect(session[:user_id]).must_equal existing_user.id
      expect(User.count).must_equal start_count
      must_redirect_to root_path
    end

    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      new_user = User.new(username: "test_user", email: "test_user@git.com", uid: 1234567890, provider: "github")
      perform_login(new_user)

      expect(session[:user_id]).must_equal User.last.id
      expect(User.count).must_equal start_count + 1
      must_redirect_to root_path
    end

    it "redirects to the login route if given invalid user data" do
      start_count = User.count
      invalid_user = User.new(username: nil, email: "sammy_sam@git.com", provider: "github")
      perform_login(invalid_user)

      expect(session[:user_id]).must_be_nil
      expect(User.count).must_equal start_count
      must_redirect_to root_path
    end
  end

  describe "logout" do
    it "will log out an exisiting user" do
      start_count = User.count
      existing_user = users(:dan)
      perform_login(existing_user)
      delete logout_path(existing_user.id)

      expect(session[:user_id]).must_be_nil
      expect(User.count).must_equal start_count
      must_redirect_to root_path
    end
  end
end
