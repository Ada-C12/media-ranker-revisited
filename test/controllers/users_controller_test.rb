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
  end 

  describe "logged out user" do 
  end 

end
