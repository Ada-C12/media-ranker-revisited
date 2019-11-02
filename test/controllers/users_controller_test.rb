require "test_helper"

describe UsersController do
  
  before do
    @user = users(:dan)
  end
  
  describe "while not logged in" do
    
    describe "index" do
      it "can get the index path" do
        get users_path
        
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "can get a valid user" do
        get user_path(@user.id)
        
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
        user = User.new(username: "steve_mctesterson", email: "steve@test.com", provider: "Github", uid: 4567)
        
        perform_login(user)
        
        must_redirect_to root_path
        _(User.count).must_equal start_count + 1
        _(session[:user_id]).must_equal User.last.id
        _(flash[:success]).wont_be_nil
      end
      
      it "can log in an existing user and redirects to the root route" do
        start_count = User.count        
        perform_login(@user)
        
        must_redirect_to root_path
        _(session[:user_id]).must_equal @user.id
        _(User.count).must_equal start_count
        _(flash[:success]).wont_be_nil
      end
      
      it "doesn't create a new account if given invalid user data" do
        start_count = User.count
        invalid_user = User.new(provider: "github", uid: nil, username: nil, email: nil)
        
        perform_login(invalid_user)
        
        must_redirect_to root_path
        _(User.count).must_equal start_count
        assert_nil(session[:user_id])
        _(flash[:warning]).wont_be_nil
      end
    end
    
    
  end
  
end

