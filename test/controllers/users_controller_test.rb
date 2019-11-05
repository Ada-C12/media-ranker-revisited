require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects them to the root path" do
      user = users(:ada)
    
      expect{
        perform_login(user)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
    end

    it "logs in a new user and redirects them back to the root path" do
      user = User.new(
        name: "gretchen",
        provider: "github",
        uid: "465",
        email: "gretchen@com"
      )

      expect {
        perform_login(user)
      }.must_change "User.count", 1

      find_user = User.find_by(name: user.name)

      must_redirect_to root_path
      expect(session[:user_id]).must_equal find_user.id
    end

    it "redirects back to the root path for invalid callbacks" do
      expect {
        perform_login(User.new)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
    end
  end

  describe "logged in user" do 
    before do
      @user = User.first
      perform_login(@user)
    end

    describe "index" do
      it "responds with success when a user has logged in" do
        get users_path
        must_respond_with :success
      end
  end 

    describe "show" do
      it "responds with success when a user id exists" do
        get user_path(@user.id)
        must_respond_with :success
      end

      it "responds with a not_found when a users id does not exist" do
        get user_path(-1)
        must_respond_with :not_found
      end
    end

    describe "destroy" do
      it "successfully logs out a logged in user" do
        expect {
          delete logout_path
        }.wont_change "User.count"

        must_redirect_to root_path
        expect(session[:user_id]).must_be_nil
        assert_equal "Successfully logged out", flash[:result_text]
      end

      it "wont log out a nonexistent user" do 
        perform_login(User.new)
        expect{
          delete logout_path
        }.wont_change "User.count"
        must_redirect_to root_path
      end 
    end
  end 

  describe "guest user" do

    describe "index" do
      it "cannot access index and responds with a redirect to the root path" do
        get users_path
        must_redirect_to root_path
      end
    end

    describe "show" do
      it "cannot access index and responds with a redirect to the root path" do
        get user_path(users(:ada).id)
        must_redirect_to root_path
      end
    end

    describe "destroy" do
      it "won't log out a user that is not logged in" do
        expect {
          delete logout_path
        }.wont_change "User.count"

        must_redirect_to root_path
        expect(session[:user_id]).must_be_nil
      end
    end 
  end 
end
