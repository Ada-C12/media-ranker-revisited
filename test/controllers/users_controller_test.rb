require "test_helper"

describe UsersController do
    describe "create -- log in with github" do 
        it "can log in returning user and redirects to root path" do
            start_count = User.count
            returning_user = users(:dan)
            perform_login(returning_user)
            
            must_redirect_to root_path
            session[:user_id].must_equal returning_user.id
            User.count.must_equal start_count
        end

        it "can log in new user and redirects to root path" do 
            start_count = User.count
            new_user = User.new(
                provider: "github", 
                uid: 99999, 
                name: "new user", 
                username: "new_user", 
                email: "test@user.com"
            )
            
            perform_login(new_user)
            
            must_redirect_to root_path
            session[:user_id].must_equal User.last.id
            User.count.must_equal start_count + 1
        end

        it "redirects to root path for invalid callbacks" do
            start_count = User.count
            perform_login(User.new)
            
            must_redirect_to root_path
            assert_nil(session[:user_id])
            User.count.must_equal start_count
        end
    end

    describe "destroy -- log out" do
        it "can log out a logged in user and redirects to root path" do 
            start_count = User.count
            returning_user = users(:dan)
            perform_login(returning_user)
            must_redirect_to root_path
            session[:user_id].must_equal returning_user.id
            User.count.must_equal start_count

            delete logout_path

            must_redirect_to root_path
            assert_nil(session[:user_id]) 
            User.count.must_equal start_count
        end
    end
end
