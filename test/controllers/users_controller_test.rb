require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in a new user and redirects them back to the root path" do
      user = User.new(
        uid: "111111",
        email: "eaball35@gmail.com",
        provider: "github",
        username: "eaball35",
        name: "Emily"
      )

      expect {
        perform_login(user)
      }.must_change "User.count", 1

      user = User.find_by(uid: user.uid)

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      assert_equal "Logged in as new user #{user.name}", flash[:success]
    end

    it "logs in an existing user and redirects them to the root path" do
      user = users(:dan)

      expect{
        perform_login(user)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      assert_equal "Logged in as returning user #{user.name}", flash[:success]
    end

    
    it "redirects back to the root path for invalid callbacks" do

      expect {
        perform_login(User.new)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
    end
  end

  describe "destroy (loggout)" do
    it "successfully logs out a logged in user" do
      user = users(:dan)
      perform_login(user)

      expect {
        delete logout_path
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
      assert_equal "Successfully logged out!", flash[:success]
    end

    it "logging out nonexistant user won't change anything" do 
      perform_login(User.new)
      
      expect { 
        delete logout_path
      }.wont_change "User.count"

      expect(session[:user_id]).must_be_nil
      refute_equal "Successfully logged out!", flash[:success]
    end 
  end
end
