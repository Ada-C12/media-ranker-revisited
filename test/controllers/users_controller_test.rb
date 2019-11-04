require "test_helper"

describe UsersController do
  let (:dan) { users(:dan) }
  let (:kari) { users(:kari) }
  
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      
      # OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(dan))
      # get auth_callback_path(:github)
      # above 2 lines refactored into line below, from test_helpers.rb
      perform_login(dan)
      
      must_redirect_to root_path
      expect(session[:user_id]).must_equal dan.id
      expect(flash[:success]).must_equal "Logged in as returning user #{dan.name}"
      expect(User.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      new_user = User.new( username: "lisa", provider: "github", uid: 333, email: "lisa@simpsons.com" )
      
      perform_login(new_user)
      expect(session[:user_id]).must_equal User.last.id
      expect(flash[:success]).must_equal "Logged in as new user #{new_user.username}"
      expect(User.count).must_equal (start_count+1)
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count
      dan2 = User.new( username: "dan", provider: "github", uid: 333, email: "evil@twin.com" )
      
      perform_login(dan2)
      expect(session[:user_id]).must_equal nil
      
      # for some reason the user.errors from perform_login()'s failed user.save doesn't stick around, so have to replicate it below
      # TO WHOEVER IS GRADING THIS, CAN YOU MAKE A COMMENT AND ENLIGHTEN ME? CUZ I'M SCRATCHING MY HEAD SUPER HARD AT THIS...
      dan2.save
      expect(flash[:error]).must_equal "Could not create new user account: #{dan2.errors.full_messages}"
      expect(User.count).must_equal (start_count)
    end
  end
  
  describe "LOGOUT" do
    it "can successfully log out" do
      perform_login(dan)
      
      delete logout_path
      expect(session[:user_id]).must_equal nil
      expect(flash[:success]).must_equal "Successfully logged out!"
      must_redirect_to root_path
    end
    
    it "if non-logged in person try to log out" do
      get root_path
      expect(session[:user_id]).must_equal nil
      
      delete logout_path
      
      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_equal "You must be logged in to view this section"
      must_redirect_to root_path
    end
  end
  
  describe "INDEX" do
    describe "Logged in users" do
      it "can see index page" do
        perform_login(dan)
        
        get users_path
        must_respond_with :success
      end
    end
    
    describe "Guests" do
      it "can't see index page" do
        get users_path
        
        must_redirect_to root_path
        expect(flash[:status]).must_equal :failure
        expect(flash[:result_text]).must_equal "You must be logged in to view this section"
      end
    end
  end
  
  describe "SHOW" do
    it "Logged in user can access show page" do
      perform_login(dan)
      
      get user_path(id: dan.id)
      must_respond_with :success
    end
    
    it "Guests can't access show page" do
      get root_path
      dan
      get user_path(id: dan.id)
      
      must_redirect_to root_path
      expect(flash[:status]).must_equal :failure
      expect(flash[:result_text]).must_equal "You must be logged in to view this section"
    end
  end
end
