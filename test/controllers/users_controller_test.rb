require "test_helper"

describe UsersController do
  describe "logged-in user" do
    before do
      perform_login
    end
    
    describe "login" do
      it "logs in an existing user" do
        start_count = User.count
        user = users(:kari)
        
        perform_login(user)
        
        must_redirect_to root_path
        expect(session[:user_id]).must_equal user.id
        
        User.count.must_equal start_count
      end
      
      it "logs in a new user and creates user in database" do
        start_count = User.count
        new_user = User.new(provider: "github", uid: 99999, username: "testing", email: "test@user.com")
        
        perform_login(new_user)
        
        must_redirect_to root_path
        expect(session[:user_id]).must_equal User.last.id
        
        User.count.must_equal (start_count + 1)
      end
      
      it "does not update session if invalid user data" do
        Vote.destroy_all
        User.destroy_all
        
        expect {
          perform_login(User.new)
        }.wont_change "User.count"
        
        assert(flash[:status] == :failure)
        expect(session[:wizard_id].must_equal nil)
      end
    end
    
    describe "logout" do
      it "can logout a user" do
        user = users(:dan)
        perform_login(user)
        
        delete logout_path
        
        must_redirect_to root_path
        refute(session[:user_id])
        assert(flash[:status] == :success)
      end
    end
  end
  
  describe "logged-out users" do
    describe "index" do
      it "redirects to root path when no user is logged in " do
        get users_path
        
        must_redirect_to :root
      end
    end
    
    describe "show" do
      it "redirects to root path when no user is logged in " do
        get user_path(users(:kari).id)
        
        must_redirect_to :root
      end
    end
    
    describe "login" do
      it "logs in an existing user" do
        start_count = User.count
        user = users(:kari)
        
        perform_login(user)
        
        must_redirect_to root_path
        expect(session[:user_id]).must_equal user.id
        
        User.count.must_equal start_count
      end
      
      it "logs in a new user and creates user in database" do
        start_count = User.count
        new_user = User.new(provider: "github", uid: 99999, username: "testing", email: "test@user.com")
        
        perform_login(new_user)
        
        must_redirect_to root_path
        expect(session[:user_id]).must_equal User.last.id
        
        User.count.must_equal (start_count + 1)
      end
      
      it "does not update session if invalid user data" do
        Vote.destroy_all
        User.destroy_all
        
        expect {
          perform_login(User.new)
        }.wont_change "User.count"
        
        assert(flash[:status] == :failure)
        expect(session[:wizard_id].must_equal nil)
      end
    end
    
    describe "logout" do
      it "cannot logout for someone who is not logged in" do
        get root_path
        refute(session[:user_id])
        delete logout_path
        
        refute(session[:user_id])
        must_redirect_to root_path
      end
    end
  end
end
