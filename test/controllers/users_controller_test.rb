require "test_helper"

describe UsersController do
  
  describe "index" do
    it "can get the index path for logged in user" do
      perform_login
      get users_path
      must_respond_with :success
    end
    
    it "will redirect if there is no logged in user" do
      get users_path
      must_respond_with :redirect
    end
  end
  
  describe "show" do
    it "can get the show path for logged in user" do
      perform_login
      get user_path(User.first.id)
      must_respond_with :success
    end
    
    it "will redirect if there is no logged in user" do
      get user_path(User.first.id)
      must_respond_with :redirect
    end
  end
  
  
  describe "create" do
    it "logs in an existing user and redirects them to the root path" do
      user = users(:valid_user)
      expect { perform_login(user) }.wont_change "User.count"
      
      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
    end
    
    it "logs in a new user and redirects them back to the root path" do
      user = User.new(name: "asdfghjkl", provider: "github", uid: 999, email: "bat@man.com")
      OmniAuth.config.mock_auth[:github] = 
      OmniAuth::AuthHash.new(mock_auth_hash(user))
      p user.errors
      count = User.count + 1
      get auth_callback_path(:github)
      expect (User.count).must_equal count
      
      user = User.find_by(uid: user.uid)
      
      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      # You can test the flash notice too!
    end
    
    it "should redirect back to root for invalid callbacks" do
      OmniAuth.config.mock_auth[:github] = 
      OmniAuth::AuthHash.new(mock_auth_hash(User.new))
      
      expect { get auth_callback_path(:github) }.wont_change "User.count"
      
      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
    end
  end
  
  describe "destroy" do
    it "logs out a logged in user" do
      perform_login
      refute_nil session[:user_id]
      
      delete logout_path
      
      expect (session[:user_id]).must_equal nil
      must_redirect_to root_path
    end
  end
end
