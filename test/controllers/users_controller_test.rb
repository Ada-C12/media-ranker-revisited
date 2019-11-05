require "test_helper"

describe UsersController do
  describe "auth_callback" do 
    it "logs in an existing user and redirects to the homepage" do 
      # Arrange
      start_count = User.count 
      user = users(:dan)
      
      #Act
      perform_login(user)
      
      #Assert
      must_redirect_to root_path
      session[:user_id].must_equal user.id 
      User.count.must_equal start_count
      
    end
    
    it "creates an account for a new user and redirects to the homepage" do 
      # Arrange
      start_count = User.count
      new_user = User.create(provider: "github", uid: 34567, username: "new_user", email: "newbie@tests.com")
      
      # Act
      perform_login(new_user)
      
      # Assert
      must_redirect_to root_path 
      User.count.must_equal (start_count + 1)
      session[:user_id].must_equal new_user.id
    end
    
    it "redirects to the login route when given invalid data" do 
      # Arrange
      start_count = User.count 
      bad_user = User.new()
      
      # Act
      perform_login(bad_user)
      
      # Assert
      must_redirect_to root_path
      User.count.must_equal start_count
      session[:user_id].must_be_nil
    end
  end
  
  describe "logout" do 
    it "can log out, set session to nil, and redirect to root_path" do 
      # Arrange
      start_count = User.count 
      user = users(:dan)
      perform_login(user)
      
      # Act
      delete logout_path
      
      
      # Assert
      expect(session[:user_id]).must_be_nil
      must_redirect_to root_path
    end
  end
  
  describe "guest user" do 
    describe "index" do 
      it "can get the index path" do 
        # Act
        get users_path
        
        # Assert
        must_respond_with :success
      end
    end
    
    describe "show" do 
      it "can look up a valid user" do 
        user = users(:dan)
        get user_path(user.id)
      end
      
      it "should redirect with an invalid user" do 
        # Act
        get user_path(-5)
        
        # Assert
        must_respond_with :missing 
      end
    end
  end
end
