require "test_helper"

describe UsersController do
  describe "create" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      user = users(:dan)

      perform_login(user)
      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id

      expect(User.count).must_equal start_count
    end

    it "creates an account for a new user and redirects to the root route" do
      new_user = User.new(provider: "github", uid: 98765, username: "Spongebob", email: "Spongebob@bikinibottom.com")

      expect {
        perform_login(new_user)
      }.must_change "User.count", 1

      must_redirect_to root_path
      expect(session[:user_id]).must_equal User.last.id
    end

    it "redirects to the login route if given invalid user data" do
      expect {
        perform_login(User.new)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id].must_equal nil)
    end
  end

  describe "destroy" do
    it "can logout a user" do
      user = users(:kari)
      perform_login(user)

      delete logout_path

      refute(session[:user_id])
      must_redirect_to root_path
      
    end

    it "cannot logout when you aren't logged in" do
      delete logout_path

      must_redirect_to root_path
    end
  end
end
