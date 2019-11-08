require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to root path" do
      start_count = User.count
      user = users(:kari)
      perform_login(user)
      
      expect(session[:user_id]).must_equal user.id
      expect(User.count).must_equal start_count
      must_redirect_to root_path
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      user = User.new(provider: "github", uid: 99999, username: "test_user", email: "test@user.com")
      user.save
      
      perform_login(user)
      
      expect(session[:user_id]).must_equal User.last.id
      expect(User.count).must_equal start_count + 1
      must_redirect_to root_path
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count
      user = User.new(provider: "github", email: "test@user.com")
      
      perform_login(user)
      
      expect(User.count).must_equal start_count
      must_redirect_to root_path
    end
  end 
  
  describe "logged in users" do 
    describe "destroy" do 
      it "logs out a user" do 
        start_count = User.count
        user = users(:kari)
        perform_login(user)
        
        expect(session[:user_id]).must_equal user.id
        delete logout_path
        
        expect(session[:user_id]).must_be_nil
        expect(User.count).must_equal start_count
        must_redirect_to root_path
      end
    end
  end
end
