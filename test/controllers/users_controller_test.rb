require "./test/test_helper"

describe UsersController do
  describe "auth_callback" do
    describe "login" do
      it "logs in an existing user and redirects to the root route" do
        start_count = User.count

        user = users(:georgina)

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

        get auth_callback_path(:github)

        must_redirect_to root_path

        session[:user_id].must_equal user.id

        User.count.must_equal start_count
      end

      it "creates an account for a new user and redirects to the root route" do
        start_count = User.count
        new_user = User.new(provider: "github", uid: 123456, name:"georgina", username: "newbie", email: "test@example.com")
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
        
        get auth_callback_path(:github)
        
        must_redirect_to root_path
        expect(session[:user_id]).must_equal User.last.id
        expect(flash[:success]).must_include "Logged in as new user #{User.last.name}"
        expect(User.count).must_equal start_count + 1
      end

      it "redirects to the login route if given invalid user data" do
        start_count = User.count
        new_user = User.new(provider: "github", uid: 928363, email: "test@example.com")
        
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
        
        get auth_callback_path(:github)
        
        must_redirect_to root_path
        expect(flash[:error]).wont_be_nil
        expect(User.count).must_equal start_count
      end
    end

    describe "log out" do
      it "logs out a user" do
        start_count = User.count
        user = users(:georgina)
        
        perform_login(user)
        expect(session[:user_id]).must_equal user.id
        
        delete logout_path
        must_redirect_to root_path
        expect(session[:user_id]).must_be_nil
        expect(flash[:success]).must_equal "Successfully logged out!"
        expect(User.count).must_equal start_count
      end
    end
  end
end
