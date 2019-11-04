require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in the first existing user and redirects them to the root path" do
      expect{
        perform_login
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal User.first.id
      assert_equal "Logged in as returning user #{User.first.username}", flash[:result_text]
    end

    it "logs in a new user and redirects them back to the root path" do
      user = User.new(
        username: "jane",
        provider: "github",
        uid: 666,
        email: "jane@eamil.com",
      )

      expect {
        perform_login(user)
      }.must_change "User.count", 1

      user = User.find_by(uid: user.uid)

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      assert_equal "Logged in as new user #{user.username}", flash[:result_text]
    end

    it "should redirect back to the root path for invalid callbacks" do
      expect{
        perform_login(User.new)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
      assert_equal "Could not create new user account:", flash[:result_text]
    end
  end
end
