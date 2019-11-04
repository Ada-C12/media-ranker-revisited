require "test_helper"

describe UsersController do

  describe "auth_callback" do 
    it "logs in an existing user and redirects to the root path" do 
      user = users(:dan)

      expect {
        perform_login(user)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal User.first.id
    end 

    it "logs in a new user and redirects them to the root path" do 
      user = User.new(username: "Buddy", provider: "github", uid: 666, email: "bud@ee.com")
        expect {
          perform_login(user)
        }.must_change "User.count", 1

        user = User.find_by(uid: user.uid)

        must_redirect_to root_path
        expect(session[:user_id]).must_equal user.id 
    end

    it "redirects back to the root path for invalid callbacks" do 
      expect {
        perform_login(User.new)
      }.wont_change "User.count"
    end 
  end

  describe "logged in user" do 

    before do 
      user = User.first
      perform_login(user)
    end 

    describe "index" do
      it "can access the index" do 
        get users_path
        must_respond_with :success
      end 
    end 

    describe "show" do 
      it "responds with success when a user id exists" do 
        get user_path(users(:kari).id)
        must_respond_with :success
      end 

      it "responds with 404 when a user id does not exist" do 
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
      end 

      it "wont log out a nonexistent user" do 
        perform_login(User.new)

        expect{delete logout_path}.wont_change "User.count"
        must_redirect_to root_path 
      end 
    end
  end 

  describe "logged out user" do 

    describe "index" do
      it "can access the index" do 
        get users_path
        must_respond_with :success
      end 
    end 

    describe "show" do 
      it "responds with success when a user id exists"  do
        get user_path(users(:dan).id)
        must_respond_with :success
      end 

      it "responds with 404 when a user id does not exist" do 
        get user_path(-1)
        must_respond_with :not_found
      end 
    end 

    describe "destroy" do
      it "won't log out a user that is not logged in" do
        delete logout_path 
        expect {delete logout_path}.wont_change "User.count"

        must_redirect_to root_path
        expect(session[:user_id]).must_be_nil
      end
    end 
  end 


end
