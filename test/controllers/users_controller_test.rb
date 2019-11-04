require "test_helper"

describe UsersController do
  describe "guest user (not authenticated)" do
    describe "index" do
      it "should display all users" do
        get users_path
        
        must_respond_with :success
      end
      
      it "should not break if there are no users" do 
        User.destroy_all
        
        get users_path
        
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "should respond with success when given a valid user" do
        valid_user = users(:dan)
        
        get user_path(valid_user.id)
        must_respond_with :success
      end
      
      it "should respond with redirect with an invalid user" do 
        get user_path(-1)
        
        must_respond_with :not_found
      end
    end
  end
  
  describe "authenticated user" do
    before do
      perform_login(users(:dan))
    end
    
    describe "logout" do
      it "successfully logs out current user" do
        expect(session[:user_id].nil?).must_equal false
        
        post logout_path
        
        assert_nil(session[:user_id])
        expect(flash[:success]).must_equal "Successfully logged out!"
        
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
  end
  
  describe "auth_callback" do
    it "logs in an existing user and redirects" do
      start_count = User.count
      
      user = users(:dan)
      
      perform_login(user)
      
      must_respond_with :redirect
      must_redirect_to root_path
      
      expect(flash[:success]).must_equal "Logged in as returning user #{user.username}"
      expect(User.find_by(id: session[:user_id])).must_equal user
      expect(User.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects" do
      new_user = User.new(username: "random name", email: "whatev@git.com", uid: 473837)
      
      expect{ 
        perform_login(new_user) 
      }.must_change "User.count", 1

      found_user = User.find_by(username: new_user.username)
      
      expect(flash[:success]).must_equal "Logged in as new user #{new_user.username}"

      expect(User.find_by(id: session[:user_id])).must_equal found_user
      
      must_respond_with :redirect
      must_redirect_to root_path
    end
    
    it "redirects to the login route if given invalid user data" do      
      new_user = User.new(username: "dan")
      
      expect{ 
        perform_login(new_user)
      }.wont_change "User.count"

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
end
