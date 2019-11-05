require "test_helper"

describe UsersController do
  before do
    @user = users(:dan)
  end
  
  describe "as a guest user" do
    describe "index" do
      it "can get the index path" do
        get users_path
        
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "can get a valid user" do
        get user_path(User.first.id)
        
        must_respond_with :success
      end
      
      it "will redirect for an invalid user" do
        get user_path(-1)
        
        must_respond_with :not_found
      end
    end
    
    describe "create" do
      it "can create an account for a new user and redirects to root route" do
        start_count = User.count
        user = User.new(provider: "github", uid: 1789, username: "test_user", email: "test@user.com")
        
        perform_login(user)
        
        must_respond_with :redirect
        _(User.count).must_equal start_count + 1
        _(session[:user_id]).must_equal User.last.id
        _(flash[:success]).wont_be_nil
      end
      
      it "can log in an existing user and redirects to the root route" do
        start_count = User.count
        
        perform_login(@user)
        
        must_respond_with :redirect
        _(session[:user_id]).must_equal @user.id
        _(User.count).must_equal start_count
        _(flash[:success]).wont_be_nil
      end
      
      it "redirects to the login route if given invalid user data" do
        start_count = User.count
        user = User.new(provider: "github", uid: nil, username: "test_user", email: "test@user.com")
        
        perform_login(user)
        
        must_redirect_to root_path
        _(User.count).must_equal start_count
        _(session[:user_id]).must_equal nil
        _(flash[:warning]).wont_be_nil
      end
    end
    
    describe "destroy" do
      it "cannot logout because guest user is not logged in" do
        start_count = User.count
        delete logout_path
        _(User.count).must_equal start_count
        _(session[:user_id]).must_equal nil
        _(flash[:warning]).wont_be_nil
      end
    end
  end
  
  describe "as a logged-in user" do
    before do
      perform_login(@user)
    end
    
    describe "index" do
      it "can get the index path" do
        get users_path
        
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "can get a valid user" do
        get user_path(User.first.id)
        
        must_respond_with :success
      end
      
      it "will redirect for an invalid user" do
        get user_path(-1)
        
        must_respond_with :not_found
      end
    end
    
    describe "create" do
      it "will not let user log in again" do
        start_count = User.count
        user = users(:dan)
        
        perform_login(user)
        
        must_respond_with :redirect
        _(User.count).must_equal start_count
        _(session[:user_id]).must_equal @user.id
        _(flash[:warning]).wont_be_nil
      end
    end
    
    describe "destroy" do
      it "can log out user" do
        start_count = User.count
        delete logout_path
        _(User.count).must_equal start_count
        _(session[:user_id]).must_equal nil
        _(flash[:success]).wont_be_nil
      end
    end
  end
end

