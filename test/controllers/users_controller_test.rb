require "test_helper"

describe UsersController do
  describe "index" do
    it "can get the index path for a logged in user" do
      perform_login
      get users_path
      must_respond_with :success
    end

    it "will redirect when no user is logged in" do
      get users_path
      must_respond_with :redirect
    end
  end

  describe "show" do
    it "can get the show path for a logged in user" do
      perform_login
      user = users(:dan)
      get user_path(user.id)
      must_respond_with :success
    end

    it "will redirect when no user is logged in" do
      get users_path
      must_respond_with :redirect
    end
  end

  describe "create" do
    it "can log in an existing user without changing user count" do
      expect{perform_login(users(:dan))}.wont_change "User.count"
    end

  end

  describe "destroy" do
    it "will logout a logged in user" do
      perform_login(users(:dan))
      expect{delete logout_path}.wont_change "User.count"
    end
  end
end
