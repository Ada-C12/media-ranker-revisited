require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      user = users(:dan)

      perform_login(user)

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      User.count.must_equal start_count
    end

    it "creates an account for a new user and redirects to the root route" do
      new_user = User.new(provider: "github", uid: 99999, username: "testing")

      expect {
        perform_login(new_user)
      }.must_change "User.count", 1

      must_redirect_to root_path
      expect(session[:user_id]).must_equal User.last.id
    end

    it "redirects to the login route if given invalid user data" do
      user = User.new

      expect {
        perform_login(user)
      }.wont_change "User.count"

      must_respond_with :bad_request
      expect(session[:user_id].must_equal nil)
    end
  end

  describe "destroy action" do
    it "can logout a user" do
      user = users(:kari)
      perform_login(user)

      delete logout_path

      must_redirect_to root_path
      refute(session[:kari_id])
      expect(flash[:result_text] == "Successfully logged out!")
    end

    it "cannot logout for someone who is not logged in" do
      get root_path
      refute(session[:kari_id])
      delete logout_path

      refute(session[:kari_id])
      must_redirect_to root_path
    end
  end
end
