require "test_helper"

describe UsersController do
  describe "create" do
    it "creates an account for a new user and redirects to root, storing logged in user's id in session" do
      new_user = User.new(
        username: "Angele",
        uid: 33245,
        provider: "github",
        name: "Angele Z",
        email: "angele@ada.com"
      )

      expect{
        perform_gh_login(new_user)
      }.must_change "User.count", 1

      new_user_id = User.find_by(username: new_user.username).id

      must_redirect_to root_path
      expect(session[:user_id]).must_equal new_user_id
    end

    it "logs in an existing user and redirects to root, storing logged in user's id in session" do
      dan = users(:dan)
      expect{
        perform_gh_login(dan)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal dan.id
    end

    it "does not create an account if login is performed with invalid User data, leaving session unchanged" do
      invalid_user = User.new() # might have to add empty params
      expect{
        perform_gh_login(invalid_user)
      }.wont_change "User.count"

      must_redirect_to root_path
      refute(session[:user_id])
    end
  end

  describe "logout" do
    it "logs out the user in session by setting session[:user_id] to nil" do
      # make sure someone is logged in
      dan = users(:dan)
      perform_gh_login(dan)
      expect(session[:user_id]).must_equal dan.id
      # log them out
      post logout_path
      # expect no one is logged in
      refute(session[:user_id])

    end

    # maybe add this test?
    # it "redirects to root and sends :bad_request response if no user was logged in" do
    # end
  end
end
