require "test_helper"

describe UsersController do
  describe "create" do
    it "creates an account for a new user and redirects to root, storing logged in user's id in session" do
    end

    it "logs in an existing user and redirects to root, storing logged in user's id in session" do
    end

    it "does not create an account if login is performed with invalid User data, leaving session unchanged" do
    end
  end

  describe "logout" do
    it "logs out the user in session by setting session[:user_id] to nil" do
    end

    # maybe add this test?
    # it "redirects to root and sends :bad_request response if no user was logged in" do
    # end
  end
end
