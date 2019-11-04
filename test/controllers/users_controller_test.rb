require "test_helper"

describe UsersController do
  describe "index" do 
    it "responds with success when there are many users" do
      get users_path
      must_respond_with :success
    end
  end

  describe "show" do 
    it "responds with success when given a valid user id" do 
      get user_path(users(:dan))
      must_respond_with :success
    end

    it "responds with 404 when given an invalid user id" do
    get user_path(-1)
    must_respond_with :not_found
    end
  end

  describe "create" do 
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count

      user = users(:dan)
      perform_login(user)

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      expect(User.count).must_equal start_count
      expect(flash[:success]).must_equal "Logged in as returning user #{user.name}"
    end

    it "creates and logs in an new user and redirects to the root route" do
      start_count = User.count
      user = User.new(name: "Allison", email: "allison@gmail.com", uid: 83358335, provider: "github")

      perform_login(user)

      expect(User.count).must_equal start_count + 1

      user= User.find_by(uid: user.uid)
      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      expect(flash[:success]).must_equal "Logged in as new user #{user.name}"
    end

    it "User count doesn't change and redirects to root path if given invalid user data" do
      start_count = User.count
      user = users(:dan)
      user.name = nil
      user.save!

      perform_login(user)

      expect {
        get auth_callback_path(:github)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_uid]).must_be_nil
    end
  end

  describe "destroy" do 
    it "responds with redirect after logging out a user" do
      user = users(:dan)
      perform_login(user)
      delete logout_path(user)

      expect(session[:user_uid]).must_be_nil
      expect(flash[:success]).must_equal "Successfully logged out!"
    end
  end
end
