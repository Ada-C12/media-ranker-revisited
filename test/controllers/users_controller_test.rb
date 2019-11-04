require "test_helper"

describe UsersController do
  describe "guest user (not authenticated)" do
    it "should show homepage" do
      get root_path 
      must_respond_with :success
    end
    
    it "redirects to root path when user is not logged in" do
      get works_path
      expect(flash[:error]).must_equal "You must be logged in to see this page."
      must_respond_with :redirect
      must_redirect_to root_path
      
      get new_work_path
      expect(flash[:error]).must_equal "You must be logged in to see this page."
      must_respond_with :redirect
      must_redirect_to root_path
      
      get edit_work_path(Work.first.id)
      expect(flash[:error]).must_equal "You must be logged in to see this page."
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
  
  describe "authenticated user" do
    before do
      user = users(:kennedy)
      perform_login(user)
    end
    
    describe "current action" do
      it "sets session[:user_id], redirects, and responds with success" do
        perform_login
        get current_user_path
        must_respond_with :redirect
      end
      
      it "sets flash[:error] and redirects when there's no user" do
        get current_user_path
        must_respond_with :redirect
      end
    end
    
    
    describe "dashboard" do
      it "shows dashboard for user that is logged in" do
        user = users(:kennedy)
        perform_login(user)
        get user_path(user.id)
        must_respond_with :success
      end
    end
    
    describe "logout" do
      it "successfully logs out current user" do
        expect(session[:user_id].nil?).must_equal false
        
        delete logout_path
        
        assert_nil(session[:user_id])
        expect(flash[:success]).must_equal "Successfully logged out!"
        
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end
    
    describe "auth_callback" do
      it "logs in an existing user and redirects" do
        start_count = User.count
        user = users(:kennedy)
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
        get auth_callback_path
        must_redirect_to user_path(user.id)
        session[:user_id].must_equal user.id
        User.count.must_equal start_count
      end
      
      it "creates an account for a new user and redirects to the root route" do
        start_count = User.count
        user = User.new(provider: "github", uid: 99999, name: "test_user", email: "test@user.com", join_date: Time.now)
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
        get auth_callback_path
        #must_redirect_to user_path(user.id)
        User.count.must_equal start_count + 1
        session[:user_id].must_equal User.last.id 
        
        # start_count = User.count
        # new_user = User.new(provider: "github", uid: 99999, name: "test_user", email: "test@user.com", join_date: Time.now)
        # expect{ 
        #   perform_login(new_user) 
        # }.must_differ "User.count", 1
        # expect(User.find_by(id: session[:user_id])).must_equal User.all.last
        # must_respond_with :redirect
        # must_redirect_to user_path(user.id)
      end
      
      it "redirects to the login route if given invalid user data" do
        start_count = User.count
        user = User.new(provider: "github", uid: 99999, join_date: Time.now)
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
        get auth_callback_path
        must_redirect_to root_path
        User.count.must_equal start_count
        session[:user_id].must_equal nil
      end
    end
  end
end

